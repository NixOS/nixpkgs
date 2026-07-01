{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kwrite";
  postUnpack = ''sed -i -z 's/# [a-zA-Z &\(\)]*\necm_optional_add_subdirectory(kate)\n*//' $(ls -d */ | grep kate)apps/CMakeLists.txt'';
}
