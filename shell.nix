{ pkgs ? import <nixpkgs> {} }:

let
  wfsToolsVersion = "1.2.3";
  wfsToolsUrl = "https://github.com/koolkdev/wfs-tools/releases/download/v${wfsToolsVersion}/wfs-tools-v${wfsToolsVersion}-linux-x86-64.zip";
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    curl
    unzip
    fuse
    makeWrapper
  ];

  shellHook = ''
    echo "Setting up WFS Tools environment..."
    
    # Create bin directory if it doesn't exist
    mkdir -p bin
    
    # Download and extract if not already done
    if [ ! -f "bin/wfs-fuse" ]; then
      echo "Downloading WFS Tools v${wfsToolsVersion}..."
      curl -L "${wfsToolsUrl}" -o wfs-tools.zip
      unzip -o wfs-tools.zip -d bin/
      rm wfs-tools.zip
      chmod +x bin/wfs-*
      
      # Wrap binaries with proper library paths
      for binary in bin/wfs-*; do
        mv "$binary" "$binary.unwrapped"
        makeWrapper "$binary.unwrapped" "$binary" \
          --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath [ pkgs.fuse ]}" \
          --suffix PATH : "${pkgs.lib.makeBinPath [ pkgs.fuse ]}"
      done
    fi
    
    # Add bin directory to PATH
    export PATH="$PWD/bin:$PATH"
    
    echo "WFS Tools environment loaded"
    echo ""
    echo "Available commands:"
    echo "  - wfs-fuse"
    echo "  - wfs-extract"
    echo "  - wfs-info"
    echo "  - wfs-reencryptor"
    echo "  - wfs-file-injector"
  '';
}
