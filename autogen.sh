#!/bin/sh

# Copyright (C) 2012 Canonical Ltd.
# Author: Martin Pitt <martin.pitt@ubuntu.com>
#
#  umockdev is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
#  umockdev is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with this program; If not, see <http://www.gnu.org/licenses/>.

set -e

mkdir -p m4
if type gtkdocize 2> /dev/null; then
    gtkdocize --docdir docs/
    args="--enable-gtk-doc"
else
    echo "gtk-doc not installed, you will not be able to generate documentation."
    echo 'EXTRA_DIST =' > docs/gtk-doc.make
fi

if type lcov >/dev/null 2>&1; then
    args="$args --enable-code-coverage"
else
    echo "lcov not installed, not enabling code coverage"
fi

# Poor attempt at fixing missing libs in Make
#flags=`pkg-config --libs --cflags gudev-1.0``pkg-config --libs --cflags gio-unix-2.0``pkg-config --libs --cflags gtk+-2.0``pkg-config --libs --cflags glib-2.0`
cflags=`pkg-config --cflags gudev-1.0``pkg-config --cflags gio-unix-2.0``pkg-config --cflags gtk+-2.0``pkg-config --cflags glib-2.0`
ldflags=`pkg-config --libs gudev-1.0``pkg-config --libs gio-unix-2.0``pkg-config --libs gtk+-2.0``pkg-config --libs glib-2.0`
autoreconf --install --symlink
[ -n "$NOCONFIGURE" ] || CFLAGS=$cflags LDFLAGS=$ldflags ./configure $args "$@"
