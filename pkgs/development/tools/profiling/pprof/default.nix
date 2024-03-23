{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pprof";
  version = "unstable-2024-02-27";

  src = fetchFromGitHub {
    owner = "google";
    repo = "pprof";
    rev = "401108e1b7e7e113ef887df16b6227698eb5bb0f";
    hash = "sha256-TD285HHXkePQA2J9W/dEciK5tOLmvbDPr54KNXeE1b4=";
  };

  vendorHash = "sha256-XOcOt+pe1lZj4XHafxROLslhyJk4mTC72yn7R1k2JCk=";

  meta = with lib; {
    description = "A tool for visualization and analysis of profiling data";
    mainProgram = "pprof";
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
