{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pprof";
<<<<<<< HEAD
  version = "unstable-2023-07-05";
=======
  version = "unstable-2022-05-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "pprof";
<<<<<<< HEAD
    rev = "200ffdc848b879f8aff937ffeba601c186916257";
    hash = "sha256-/Y1Tj9z+2MNe+b2vzd4F+PwHGSbCYP7HpbaDUL9ZzKQ=";
  };

  vendorHash = "sha256-MuejFoK49VMmLt7xsiX/4Av7TijPwM9/mewXlfdufd8=";
=======
    rev = "59ca7ad80af3faf4f87f4d82ff02f5d390c08ed6";
    sha256 = "0jni73ila3glg7rl11v0al947d94dd0syhkjqnliaryh8dkxbx80";
  };

  vendorSha256 = "0vr8jp3kxgadb73g67plfrl5dkxfwrxaxjs664918jssy25vyk2y";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool for visualization and analysis of profiling data";
    homepage = "https://github.com/google/pprof";
    license = licenses.asl20;
    longDescription = ''
      pprof reads a collection of profiling samples in profile.proto format and
      generates reports to visualize and help analyze the data. It can generate
      both text and graphical reports (through the use of the dot visualization
      package).

      profile.proto is a protocol buffer that describes a set of callstacks and
      symbolization information. A common usage is to represent a set of sampled
      callstacks from statistical profiling. The format is described on the
      proto/profile.proto file. For details on protocol buffers, see
      https://developers.google.com/protocol-buffers

      Profiles can be read from a local file, or over http. Multiple profiles of
      the same type can be aggregated or compared.

      If the profile samples contain machine addresses, pprof can symbolize them
      through the use of the native binutils tools (addr2line and nm).

      This is not an official Google product.
    '';
  };
}
