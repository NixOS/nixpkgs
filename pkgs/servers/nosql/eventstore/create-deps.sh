# 1. create a log with `dotnet restore -v m MyPackage.sln > mypackage-restore.log
# 2. then call ./create-deps.sh mypackage-restore.log

urlbase="https://www.nuget.org/api/v2/package"
cat << EOL
{ fetchurl }: let

  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    url = "$urlbase/\${name}/\${version}";
  };

in [
EOL
IFS=''
while read line; do
  if echo $line | grep -q "Installing "; then
    name=$(echo $line | sed -r 's/  Installing ([^ ]+) (.+)./\1/')
    version=$(echo $line | sed -r 's/  Installing ([^ ]+) (.+)./\2/')
    sha256=$(nix-prefetch-url "$urlbase/$name/$version" 2>/dev/null)
    cat << EOL

  (fetchNuGet {
    name = "$name";
    version = "$version";
    sha256 = "$sha256";
  })
EOL
  fi
done < $1
cat << EOL

]
EOL
