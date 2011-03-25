source $stdenv/setup
mkdir -p "$out/bin"
ln -s /usr/bin/install_name_tool "$out/bin/"
