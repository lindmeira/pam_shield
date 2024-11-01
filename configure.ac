
AC_INIT([pam-shield],[0.9.7])
AC_CONFIG_HEADERS(config.h)
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE

AC_PROG_CC
AC_PROG_INSTALL
AC_DISABLE_STATIC
LT_INIT
AC_PROG_LN_S

AC_PREFIX_DEFAULT(/usr)
AC_ARG_WITH([slibdir], AS_HELP_STRING([--with-slibdir=PATH],
    [Path to the super lib directory [/lib64]]),
    [slibdir="$withval"], [slibdir="/lib64"])
AC_SUBST(slibdir)

AC_CHECK_HEADER(gdbm.h, [],
	[AC_MSG_ERROR([You need to have gdbm-devel installed])])
AC_CHECK_HEADER(security/pam_modules.h,[have_pamheader="yes"],)
# Mac OS X 10.3 puts PAM headers in /usr/include/pam.
AC_CHECK_HEADER(pam/pam_modules.h,[have_pamheader="yes"],)
if test x"$have_pamheader" != x"yes"; then
    AC_MSG_ERROR(You are missing PAM headers)
fi

case "$host" in
(*-*-linux*)
    PAM_MODDIR="\$(slibdir)/security";
    ;;
(*-*-darwin*)
    PAM_MODDIR="/usr/lib/pam";
    ;;
(*)
    PAM_MODDIR="/usr/lib";
    ;;
esac;
AC_SUBST(PAM_MODDIR)

#This is a bad hack to use /etc instead of /usr/etc if prefix not specified
#After https://fedorahosted.org/pipermail/netcf-devel/2011-May/000540.html
#Note this makes documentation for --sysconfdir lie.
if test "$prefix" = "NONE" && test "$sysconfdir" = '${prefix}/etc' ; then
    sysconfdir='/etc'
fi
if test "$prefix" = "NONE" && test "$localstatedir" = '${prefix}/var' ; then
    localstatedir='/var'
fi

#conniptions to get real paths into the C without affecting makefiles
ac_save_prefix="$prefix"
ac_save_exec_prefix="$exec_prefix"
test "x$prefix" = xNONE && prefix=$ac_default_prefix
test "x$exec_prefix" = xNONE && exec_prefix=$prefix
REAL_ETC=`eval echo $sysconfdir`
AC_DEFINE_UNQUOTED([DEFAULT_CONFFILE], ["$REAL_ETC/security/shield.conf"],
                [Location of configuration file])
REAL_VAR=`eval echo $localstatedir`
AC_DEFINE_UNQUOTED([DEFAULT_DBFILE], ["$REAL_VAR/lib/pam_shield/db"],
                [Location of database])
REAL_SBIN=`eval echo $sbindir`
AC_DEFINE_UNQUOTED([DEFAULT_TRIGGER_CMD], ["$REAL_SBIN/shield-trigger"],
                [Command to block/unblock IP])
AC_DEFINE_UNQUOTED([PAM_SHIELD_VERSION], ["$VERSION"],
                [Version of pam_shield])
prefix="$ac_save_prefix"
exec_prefix="$ac_save_exec_prefix"

AC_ARG_VAR([PKG_CONFIG], [Path to pkg-config])
AC_CHECK_PROGS([PKG_CONFIG], [pkg-config])

AC_MSG_CHECKING([for systemd])
if [$(ps --noheader -o comm 1 | grep -q systemd)]; then
    systemd_available="yes"
else
    systemd_available="no"
fi
AC_MSG_RESULT([$systemd_available])
AM_CONDITIONAL([SYSTEMD_MANAGED], [test x"$systemd_available" = x"yes"])

AC_MSG_CHECKING([for systemd service units path])
AC_SUBST([SYSD_SERV_UNIT_PATH], [$("$PKG_CONFIG" systemd --variable=systemdsystemunitdir)])
AC_MSG_RESULT(["$SYSD_SERV_UNIT_PATH"])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
