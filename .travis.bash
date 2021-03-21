#! /bin/bash
#
# .travis.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
set -e
set -x
arg_name="$1"
shift
if test "$arg_name" != "--cmd"
then
    echo "usage : $0 --cmd [cmd]"
    exit -1
fi
cmd="$1"
shift
if false
then
    :

elif test "$cmd" = "before_install"
then

    if test -e /etc/lsb-release
    then
        . /etc/lsb-release
        sudo add-apt-repository -y ppa:inkscape.dev/stable
        sudo apt -q update
        sudo apt -y install inkscape
    fi
    cpanm --local-lib=~/perl_modules local::lib
    if test "$DISTRIB_ID" = 'Ubuntu'
    then
        if test "$DISTRIB_RELEASE" = '14.04'
        then
            sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
        fi
        eval "$(GIMME_GO_VERSION=1.13 gimme)"
    elif test -e /etc/fedora-release
    then
        sudo dnf --color=never install -y hspell-devel perl-devel ruby-devel
    fi


elif test "$cmd" = "install"
then
    cpanm --notest YAML::XS
    cpanm HTML::T5 Test::HTML::Tidy::Recursive::Strict
    h=~/Docs/homepage/homepage
    mkdir -p "$h"
    git clone https://github.com/shlomif/shlomi-fish-homepage "$h/trunk"
    sudo -H `which python3` -m pip install cookiecutter
    ( cd "$h/trunk" && perl bin/my-cookiecutter.pl )

elif test "$cmd" = "build"
then
    export SCREENPLAY_COMMON_INC_DIR="$PWD/screenplays-common"
    cd selina-mandrake/screenplay
    m()
    {
        make DBTOEPUB="/usr/bin/ruby $(which dbtoepub)" \
            DOCBOOK5_XSL_STYLESHEETS_PATH=/usr/share/xml/docbook/stylesheet/docbook-xsl-ns \
        "$@"
    }
    m
    m test
fi
