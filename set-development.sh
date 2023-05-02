#!/bin/bash

kohaplugindir="$(grep -Po '(?<=<pluginsdir>).*?(?=</pluginsdir>)' $KOHA_CONF)"
kohadir="$(grep -Po '(?<=<intranetdir>).*?(?=</intranetdir>)' $KOHA_CONF)"

rm $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/AddMARCfield001.pm

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "$SCRIPT_DIR/Koha/Plugin/Fi/KohaSuomi/AddMARCfield001.pm" $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/AddMARCfield001.pm

perl $kohadir/misc/devel/install_plugins.pl
