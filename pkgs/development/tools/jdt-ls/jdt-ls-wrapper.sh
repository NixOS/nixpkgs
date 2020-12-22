#!@shell@

# This script is a wrapper around jdt.ls.
# jdt.ls is distributed as a jar file. To launch a java jar application, we
# need to run this command:
# java $JAVA_OPTIONS -jar /paht/to/jdt.ls.jar $APP_OPTIONS

# Some options are harcoded in the script (only one specific value makes sense
# for those).
# For other options, a sensible default is provided but it's possible to
# override its value.
# The script adds an argument, --java-opts, to add more java options.
# Any other arguments will be considered jdt.ls options, and appended to the
# command.

# Documentation about the arguments:
# https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line
# Some of the values are the recommended by the nvim client:
# https://github.com/mfussenegger/nvim-jdtls#language-server-installation

# Script hardcoded arguments

## jdt.ls options:
## --add-modules=ALL-SYSTEM
## --add-opens java.base/java.util=ALL-UNNAMED
## --add-opens java.base/java.lang=ALL-UNNAMED
##     Those are needed to start jdt.ls, see
##     https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line

# Script overrideable arguments

## Java options:
## -Xms1g
##     Sets the initial size of the heap
## -Xmx2G
##     Specifies the maximum size of the memory allocation pool in bytes
## -Dlog.level=INFO
##     Set the log level system property. This value is read by jdt.ls
## --java-opts
##     Extra options to the java command, empty by default
##     Notice that instead you can also use the JDK_JAVA_OPTIONS (requires Java 9)
##     and the JAVA_TOOL_OPTIONS environment variable. For more info see:
##     https://docs.oracle.com/en/java/javase/11/tools/java.html#GUID-3B1CE181-CD30-4178-9602-230B800D4FAE
##     https://docs.oracle.com/en/java/javase/11/troubleshoot/environment-variables-and-system-properties.html#GUID-BE6E7B7F-A4BE-45C0-9078-AA8A66754B97

## jdt.ls options:
## -configuration
##     Path to the configuration directory. A config.ini file is expected in
##     this directory (for more info see jdt.ls docs). The script will copy here
##     a valid config.ini file from the nix store. The properties on this file can
##     be overriden with the java -D option
##     Logs are also writen in this directory.
##     Logs and config directories are mixed, see
##     https://github.com/eclipse/eclipse.jdt.ls/issues/1097
##     By default we create a temporary directory, since the directory has to
##     be writable, and the language server logs are usually not important to the end user.
##     If you don't override the default value, this directory is deleted when the script exits
## -data
##     Data directory (also called workspace directory in jdt.ls docs) is used as
##     some kind of cache by jdt.ls. For that reason, we want to use different
##     directories per project. Defaults to $XDG_CACHE_HOME/jdtls/`basename $PWD`
##     Data directory CANNOT be in the project itself, it needs to be in a different
##     directory

# Example:

# jdt-ls -Xms500M --java-opts "-Xdiag -showversion" -data /tmp/jdtls_workspace
#
# === executes ===>
#
# java \
#  -Xms500M \
#  -Xmx2G \
#  -Dlog.level=INFO  \
#  -Xdiag \
#  -showversion \
#  -jar /nix/store/...equinox.launcher.jar \
#  --add-modules=ALL-SYSTEM \
#  --add-opens java.base/java.util=ALL-UNNAMED \
#  --add-opens java.base/java.lang=ALL-UNNAMED \
#  -configuration /tmp/jdtls_config/stXVO \
#  -data /tmp/jdtls_workspace

# Java options
log_level="-Dlog.level=INFO"
xms="-Xms1g"
xmx="-Xmx2G"

# jdt.ls options
mkdir -p /tmp/jdtls_config
configuration="$(mktemp -d /tmp/jdtls_config/XXXXX)"
trap "{ rm -rf $configuration; }" EXIT

data="${XDG_CACHE_HOME:-$HOME/.cache}/jdtls/${PWD##*/}"

# Parse the arguments
params=("$@")
extra_java_options=()
extra_args=()
for ((n = 0; n < ${#params[*]}; n += 1)); do
    p="${params[$n]}"
    if [[ "$p" == "-Dlog.level="* ]]; then
        log_level="$p"
    elif [[ "$p" == "-Xms"* ]]; then
        xms="$p"
    elif [[ "$p" == "-Xmx"* ]]; then
        xmx="$p"
    elif [[ "$p" == "--java-opts" ]]; then
        extra_java_options="${params[$((n + 1))]}"
        n=$((n + 1))
    elif [[ "$p" == "-configuration" ]]; then
        configuration="${params[$((n + 1))]}"
        n=$((n + 1))
    elif [[ "$p" == "-data" ]]; then
        data="${params[$((n + 1))]}"
        n=$((n + 1))
    else
        extra_args+=("$p")
    fi
done

cp @config_path@/config.ini "$configuration"

# use java version from PATH, @jdk@ as fallback
java_bin=$(command -v java || echo "@jdk@")
$java_bin \
    "$xms" \
    "$xmx" \
    "$log_level" \
    $extra_java_options -jar @launcher@ \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED \
    -configuration "$configuration" \
    -data "$data" ${extra_args[@]}
