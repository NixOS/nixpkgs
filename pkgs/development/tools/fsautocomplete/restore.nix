{dotnet, nuget-to-nix, writeShellScript }:
writeShellScript "fsautocomplete-restore.sh"
''
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
export DOTNET_NOLOGO=1 # Disables the welcome message
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_WORKLOAD_INTEGRITY_CHECK=1 # Skip integrity check on first run, which fails due to read-only directory

export DOTNET_CLI_HOME="$(pwd)"/cli-home/
echo $DOTNET_CLI_HOME
# we need all the tools present during build phase, even though only paket is actually used
${dotnet} tool restore

export NUGET_PACKAGES="$(pwd)"/packages/
echo $NUGET_PACKAGES
# simple dotnet restore doesn't restore all packages, even though it also calls paket restore (apparently some flags or whatnot are different)
${dotnet} paket restore -f
${dotnet} restore --packages $NUGET_PACKAGES
cp -r "$DOTNET_CLI_HOME"/.nuget/packages/* "$NUGET_PACKAGES"

# Ref and host assemblies come from our sdk runtime collection also, and result in symlink conflicts. So we remove them with grep.
${nuget-to-nix}/bin/nuget-to-nix $NUGET_PACKAGES | grep -vie "\(\.ref\"\|\.host\.\)" > deps.nix
''

