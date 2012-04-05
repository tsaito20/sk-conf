# Use ccache by default.  Users who don't want that can setenv the
# CCACHE_DISABLE environment variable in their personal profile.

if ( "$path" !~ */usr/lib64/ccache* ) then
    set path = ( /usr/lib64/ccache $path )
endif

# If /var/cache/ccache is writable, use a shared cache there, except for root.
# Users who don't want that even if they have the write permission can setenv
# the CCACHE_DIR environment variable to another location and possibly unsetenv
# the CCACHE_UMASK environment variable in their personal profile.

if ( $?CCACHE_DIR ) then
    if ( ! -w "$CCACHE_DIR" ) then
        # Reset broken settings maybe inherited when switching users (#651023).
        unsetenv CCACHE_DIR
        unsetenv CCACHE_UMASK
    endif
else if ( $uid != 0 ) then
    if ( -w /var/cache/ccache && -d /var/cache/ccache ) then
        # Set up the shared cache.
        setenv CCACHE_DIR /var/cache/ccache
        setenv CCACHE_UMASK 002
        unsetenv CCACHE_HARDLINK
    endif
endif

setenv CCACHE_HASHDIR
