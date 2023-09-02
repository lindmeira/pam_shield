AUTOMAKE_OPTIONS   = foreign subdir-objects
moduledir          = @PAM_MODDIR@
module_LTLIBRARIES = pam_shield.la
sbin_PROGRAMS      = shield-purge
dist_sbin_SCRIPTS  = scripts/*
securitydir        = ${sysconfdir}/security
dist_security_DATA = shield.conf
pamcfgdir          = ${datarootdir}/pam-configs
dist_pamcfg_DATA   = pam-configs/pam_shield
if SYSTEMD_MANAGED
servunitdir        = @SYSD_SERV_UNIT_PATH@
dist_servunit_DATA = systemd/shield.service systemd/shield.timer
enable_service     = systemctl enable --no-reload --now shield.timer
else
crondir            = ${sysconfdir}/cron.daily
dist_cron_SCRIPTS  = cron.daily/pam_shield
endif
dist_man_MANS      = man/shield.conf.5 man/shield-purge.8 man/shield-trigger.8 man/shield-trigger-iptables.8 man/shield-trigger-ufw.8
EXTRA_DIST         = CREDITS Changelog autogen.sh

AM_CFLAGS = -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
            -D_REENTRANT -Wall -Wmissing-declarations -Wmissing-prototypes \
            -Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe

pam_shield_la_LDFLAGS = -module -avoid-version
pam_shield_la_LIBADD  = -lgdbm -lpam
pam_shield_la_SOURCES = pam_shield.c pam_shield_lib.c \
			pam_shield.h pam_shield_lib.h
shield_purge_LDFLAGS  = -lgdbm
shield_purge_SOURCES = shield_purge.c pam_shield_lib.c pam_shield_lib.h
shield_purge_CFLAGS = $(AM_CFLAGS)

NORMAL_UNINSTALL = $$(test -f ${servunitdir}/shield.timer && systemctl disable --no-reload --now shield.timer || exit 0)

install-exec-hook:
	rm -f "${DESTDIR}${moduledir}/pam_shield.la";
	${INSTALL} -dm0755 "${DESTDIR}${sbindir}";
	${INSTALL} -dm0755 "${DESTDIR}${localstatedir}/lib/pam_shield";
	> "${DESTDIR}${localstatedir}/lib/pam_shield/db";

#The slib dir isn't considered exec, so make sure this really runs
#after libtool dumps the la
install-data-hook:
	rm -f "${DESTDIR}${moduledir}/pam_shield.la";
	${INSTALL} -dm0755 "${DESTDIR}${sbindir}";
	-$(enable_service)

#Remove the .so by hand; since we remove the .la, libtool won't get the .so
#also clean up the database
uninstall-hook:
	rm -f "${DESTDIR}${moduledir}/pam_shield.so";
	rm -f "${DESTDIR}${localstatedir}/lib/pam_shield/db";
	rmdir --ignore-fail-on-non-empty "${DESTDIR}${localstatedir}/lib/pam_shield";
