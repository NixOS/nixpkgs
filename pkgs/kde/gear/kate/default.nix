{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kate";
  postUnpack = ''sed -i -z 's/# [a-zA-Z &\(\)]*\necm_optional_add_subdirectory(kwrite)\n*//' $(ls -d */ | grep kate)apps/CMakeLists.txt'';
}
