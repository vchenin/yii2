#!/bin/sh

displayHelp ()
{
    cat <<__EOT__

Usage: $(basename $0) OPTIONS

  Script for composer installation.

Options:
                    
  -g, --global              Install composer to the system.
  -h, --help                Display this help and exit.
  -l, --local               Install composer to the current directory.
  -o OPTS, --options OPTS   Install composer with specified options.

Options for composer installer:
      --filename=NAME       Specify the filename (default: composer.phar).
      --install-dir=DIR     Specify directory for installation.
      --version=VER         Specify release version.
__EOT__
    exit
}

getComposer ()
{
    php -r "readfile('https://getcomposer.org/installer');" | php -- "$@"
}

operate ()
{
    case "${1:--h}" in
        -g|--global) getComposer --install-dir=/usr/local/bin --filename=composer ;;
        -h|--help) displayHelp ;;
        -l|--local) getComposer ;;
        -o|--options) shift; getComposer "$@" ;;
    esac
}

[ $# -eq 0 ] && displayHelp || operate "$@"
