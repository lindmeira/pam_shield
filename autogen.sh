#!/bin/sh

export AUTOMAKE=/usr/bin/automake
export ACLOCAL=/usr/bin/aclocal

exec autoreconf -fi;
