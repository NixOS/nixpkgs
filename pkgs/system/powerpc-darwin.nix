{ inherit ((import ./all-packages.nix) {system = "powerpc-darwin7.3.0";})
    aterm strategoxt subversion;
}
