AM_CFLAGS = -pedantic -Wall -Wextra $(GTK_CFLAGS) -DPKGDATADIR=\"$(pkgdatadir)\"
AM_LDFLAGS =

bin_PROGRAMS = ssh-askpass-fullscreen
ssh_askpass_fullscreen_SOURCES = ssh-askpass-fullscreen.c
ssh_askpass_fullscreen_LDADD = $(GTK_LIBS)
pkgdata_DATA = background.png
