# Define the list of system with their properties.  Only systems tested for
# Nixpkgs are listed below

with import ./lists.nix;
with import ./types.nix;
with import ./attrsets.nix;

let
  lib = import ./default.nix;
  setTypes = type:
    mapAttrs (name: value:
      setType type ({inherit name;} // value)
    );
in

rec {

  isSignificantByte = x: typeOf x == "significant-byte";
  significantBytes = setTypes "significant-byte" {
    bigEndian = {};
    littleEndian = {};
  };


  isCpuType = x: typeOf x == "cpu-type"
    && elem x.bits [8 16 32 64 128]
    && (builtins.lessThan 8 x.bits -> isSignificantByte x.significantByte);

  cpuTypes = with significantBytes;
    setTypes "cpu-type" {
      arm =      { bits = 32; significantByte = littleEndian; };
      armv5tel = { bits = 32; significantByte = littleEndian; };
      i686 =     { bits = 32; significantByte = littleEndian; };
      powerpc =  { bits = 32; significantByte = bigEndian; };
      x86_64 =   { bits = 64; significantByte = littleEndian; };
    };


  isExecFormat = x: typeOf x == "exec-format";
  execFormats = setTypes "exec-format" {
    aout = {}; # a.out
    elf = {};
    macho = {};
    pe = {};
    unknow = {};
  };


  isKernel = x: typeOf x == "kernel";
  kernels = with execFormats;
    setTypes "kernel" {
      cygwin =  { execFormat = pe; };
      darwin =  { execFormat = macho; };
      freebsd = { execFormat = elf; };
      linux =   { execFormat = elf; };
      netbsd =  { execFormat = elf; };
      none =    { execFormat = unknow; };
      openbsd = { execFormat = elf; };
      win32 =   { execFormat = pe; };
    };


  isArchitecture = x: typeOf x == "architecture";
  architectures = setTypes "architecture" {
    apple = {};
    pc = {};
    unknow = {};
  };


  isSystem = x: typeOf x == "system"
    && isCpuType x.cpu
    && isArchitecture x.arch
    && isKernel x.kernel;

  mkSystem = {
    cpu ? cpuTypes.i686,
    arch ? architectures.pc,
    kernel ? kernels.linux,
    name ? "${cpu.name}-${arch.name}-${kernel.name}"
  }: setType "system" {
    inherit name cpu arch kernel;
  };


  isDarwin = matchAttrs { kernel = kernels.darwin; };
  isLinux = matchAttrs { kernel = kernels.linux; };
  isi686 = matchAttrs { cpu = cpuTypes.i686; };
  is64Bit = matchAttrs { cpu = { bits = 64; }; };


  # This should revert the job done by config.guess from the gcc compiler.
  mkSystemFromString = s: let
    l = lib.splitString "-" s;

    getCpu = name:
      attrByPath [name] (throw "Unknow cpuType `${name}'.")
        cpuTypes;
    getArch = name:
      attrByPath [name] (throw "Unknow architecture `${name}'.")
        architectures;
    getKernel = name:
      attrByPath [name] (throw "Unknow kernel `${name}'.")
        kernels;

    system =
      if builtins.length l == 2 then
        mkSystem rec {
          name = s;
          cpu = getCpu (head l);
          arch =
            if isDarwin system
            then architectures.apple
            else architectures.pc;
          kernel = getKernel (head (tail l));
        }
      else
        mkSystem {
          name = s;
          cpu = getCpu (head l);
          arch = getArch (head (tail l));
          kernel = getKernel (head (tail (tail l)));
        };
  in assert isSystem system; system;
}
