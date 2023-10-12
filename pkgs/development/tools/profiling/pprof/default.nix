{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pprof";
  version = "unstable-2023-07-05";

  src = fetchFromGitHub {
    owner = "google";
    repo = "pprof";
    rev = "200ffdc848b879f8aff937ffeba601c186916257";
    hash = "sha256-/Y1Tj9z+2MNe+b2vzd4F+PwHGSbCYP7HpbaDUL9ZzKQ=";
  };

  vendorHash = "sha256-MuejFoK49VMmLt7xsiX/4Av7TijPwM9/mewXlfdufd8=";

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
