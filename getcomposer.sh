#!/bin/sh

getcomposer ()
{
    php -r "readfile('https://getcomposer.org/installer');" | php -- "$@"
}

options ()
{
    case "${1:--h}" in
        -g|--global) getcomposer --install-dir=/usr/local/bin --filename=composer ;;
        -h|--help) usage ;;
        -l|--local) getcomposer ;;
        -o|--options) shift; getcomposer "$@" ;;
    esac
}

usage ()
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
      --install-dir=DIR     Specify directory for installation.
      --filename=NAME       Specify the filename (default: composer.phar).
      --version=VER         Specify release version.
__EOT__
    exit
}

[ $# -eq 0 ] && usage || options "$@"
