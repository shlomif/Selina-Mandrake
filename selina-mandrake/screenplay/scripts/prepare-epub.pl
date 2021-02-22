#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Shlomif::Screenplays::EPUB ();

my $fron     = 'fron-demon-illustration-small-indexed.png';
my $wandless = 'emma-watson-wandless.svg.webp';
my $obj      = Shlomif::Screenplays::EPUB->new(
    {
        images => {
            $fron     => "images/$fron",
            $wandless => "images/$wandless",
        },
    }
);
$obj->run;

my $gfx = $obj->gfx;

{
    my $epub_basename = 'selina-mandrake';
    $obj->epub_basename($epub_basename);

    $obj->output_json(
        {
            data => {
                filename => $epub_basename,
                title    => q/Selina Mandrake - The Slayer/,
                authors  => [
                    {
                        name => "Shlomi Fish",
                        sort => "Fish, Shlomi",
                    },
                ],
                contributors => [
                    {
                        name => "Shlomi Fish",
                        role => "oth",
                    },
                ],
                cover  => "images/$gfx",
                rights =>
"Creative Commons Attribution ShareAlike Unported 3.0 (CC-by-sa-3.0)",
                publisher => 'http://www.shlomifish.org/',
                language  => 'en-GB',
                subjects  => [
                    'FICTION/Horror',
                    'FICTION/Humorous',
                    'FICTION/Masups',
                    ' FICTION/Science Fiction/General',
                    'HUMOR/Topic/Religion',
                    'HUMOR/Form/Parodies',
                    'Vampires',
                    'Buffy',
                ],
                identifier => {
                    scheme => 'URL',
                    value  =>
                        'http://www.shlomifish.org/humour/Selina-Mandrake/',
                },
            },
        },
    );
}
