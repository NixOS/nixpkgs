{stdenv, lib, dict}:
({dictlist, allowList ? ["127.0.0.1"], denyList ? []}:
/*
 dictlist is a list of form 
 [ { filename = /path/to/files/basename;
 name = "name"; } ]
 basename.dict.dz and basename.index should be 
 dict files. Or look below for other options.
 allowList is a list of IP/domain *-wildcarded strings
 denyList is the same..
*/

let
	link_arguments = map 
			(x: '' "${x.filename}" '')
			dictlist; 
	databases = lib.concatStrings (map (x : 
		"
			database ${x.name} {
				data ${x.filename}.dict.dz
				index ${x.filename}.index
				index_word ${x.filename}.word
				index_suffix ${x.filename}.suffix
			}
		") dictlist);
	allow = lib.concatStrings (map (x: "allow ${x}\n") allowList);
	deny = lib.concatStrings (map (x: "deny ${x}\n") denyList);
	accessSection = "
		access {
			${allow}
			${deny}
		}
	";
	installPhase = ''  
  	ensureDir $out/share/dictd
	cd $out/share/dictd
	for j in ${toString link_arguments}; do 
		if test -d "$j"; then
			if test -d "$j"/share/dictd ; then
				echo "Got store path $j"
				j="$j"/share/dictd 
			fi
			echo "Directory reference: $j"
			i=$(ls "$j"/*.index)
			i="''${i%.index}";
		else
			i="$j";
		fi
		echo "Basename is $i"
		if test -e "$i".dict.dz; then
			ln -s "$i".dict.dz
		else
			cp "$i".dict .
			dictzip "$(basename "$i")".dict
		fi
		ln -s "$i".index .
		locale=$(cat "$(dirname "$i")"/locale)
		LC_ALL=$locale dictfmt_index2word < "$(basename "$i")".index > "$(basename "$i")".word || true
		LC_ALL=$locale dictfmt_index2suffix < "$(basename "$i")".index > "$(basename "$i")".suffix || true
	done
	echo "${accessSection}" > dictd.conf
	cat <<EOF >> dictd.conf
${databases}
EOF
  	'';

in

stdenv.mkDerivation {
  name = "dictd-dbs";

  phases = ["installPhase"];
  buildInputs = [dict];

  inherit installPhase;
})
