#!@bash@
# CUPS filter: job user title copies options [file]
# Brother's own wrapper passes the job options through brprintconf_hl3140cw,
# which only writes to /opt/brother. This one writes the queue's PPD defaults,
# then the job's options, into a per-job copy of the rc file instead.
set -eu
PATH=@path@
base=@out@/opt/brother/Printers/hl3140cw
opts=" $5 "
ppd=${PPD:-}

# $1 = PPD keyword; prints the job's value, else the PPD default.
get() {
  v=$(printf '%s' "$opts" | grep -o " $1=[^ ]*" | tail -n1 | cut -d= -f2-) || true
  if [ -z "$v" ] && [ -r "$ppd" ]; then
    v=$(sed -n "s/^\*Default$1: *//p" "$ppd" | head -n1)
  fi
  printf '%s' "$v"
}

page=$(get PageSize)
if ! printf '%s' "$opts" | grep -q ' PageSize='; then
  case $(printf '%s' "$opts" | grep -o ' media=[^ ]*' | tail -n1) in
    *[Aa]4*) page=A4 ;;
    *[Ll]etter*) page=Letter ;;
    *[Ll]egal*) page=Legal ;;
    *[Aa]5*) page=A5 ;;
    *[Aa]6*) page=A6 ;;
    *[Ee]xecutive*) page=Executive ;;
  esac
fi
page=${page:-A4}
case $page in
  B5) page=ISOB5 ;;
  A5Rotated) page=PRA5Rotated ;;
esac
reso=$(get BRResolution)
case $reso in
  600x2400dpi) reso=Fine ;;
  *) reso=Normal ;;
esac

rc=$(mktemp "${TMPDIR:-/tmp}/brhl3140cwrc.XXXXXX")
trap 'rm -f "$rc"' EXIT
sed -e "s/^PageSize=.*/PageSize=$page/" \
  -e "s/^BRResolution=.*/BRResolution=$reso/" \
  "$base/inf/brhl3140cwrc" > "$rc"
# rc key  PPD keyword
while read -r key kw; do
  v=$(get "$kw")
  if [ -n "$v" ]; then sed -i "s/^$key=.*/$key=$v/" "$rc"; fi
done <<'MAP'
MediaType BRMediaType
InputSlot BRInputSlot
BRMonoColor BRMonoColor
BRColorMatching BRColorMatching
BRGray BRGray
BREnhanceBlkPrt BREnhanceBlkPrt
TonerSaveMode BRTonerSaveMode
BRImproveOutput BRImproveOutput
BRSkipBlank BRSkipBlank
Brightness BRBrightness
Contrast BRContrast
RedKey BRRed
GreenKey BRGreen
BlueKey BRBlue
Saturation BRSaturation
MAP

export BRPRINTERRCFILE=$rc
if [ $# -ge 6 ]; then exec < "$6"; fi
"$base/lpd/filterhl3140cw"
