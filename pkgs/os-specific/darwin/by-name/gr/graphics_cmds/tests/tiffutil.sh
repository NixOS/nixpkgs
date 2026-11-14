#!/usr/bin/env atf-sh

usage_message=$(tiffutil)

atf_test_case none_writes_out_tiff_with_no_compression
none_writes_out_tiff_with_no_compression_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -none "$(atf_get_srcdir)/data/input-test-file.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-compression-none.tiff" out.tiff
}

atf_test_case none_with_too_many_filenames_fails_with_an_error
none_with_too_many_filenames_fails_with_an_error_body() {
    expected_message="Error: One input file name expected.\n$usage_message\n"
    atf_check -s exit:1 -o inline:"$expected_message" tiffutil -none a.tiff b.tiff
}

atf_test_case lzw_writes_out_tiff_with_lzw_compression
lzw_writes_out_tiff_with_lzw_compression_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -lzw "$(atf_get_srcdir)/data/input-test-file.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-compression-lzw.tiff" out.tiff
}

atf_test_case lzw_with_too_many_filenames_fails_with_an_error
lzw_with_too_many_filenames_fails_with_an_error_body() {
    expected_message="Error: One input file name expected.\n$usage_message\n"
    atf_check -s exit:1 -o inline:"$expected_message" tiffutil -lzw a.tiff b.tiff
}

atf_test_case packbits_writes_out_tiff_with_packbits_compression
packbits_writes_out_tiff_with_packbits_compression_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -packbits "$(atf_get_srcdir)/data/input-test-file.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-compression-packbits.tiff" out.tiff
}

atf_test_case packbits_with_too_many_filenames_fails_with_an_error
packbits_with_too_many_filenames_fails_with_an_error_body() {
    expected_message="Error: One input file name expected.\n$usage_message\n"
    atf_check -s exit:1 -o inline:"$expected_message" tiffutil -packbits a.tiff b.tiff
}

atf_test_case cat_implements_buggy_dpi_handling
cat_implements_buggy_dpi_handling_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file-weird-dpi.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-buggy-dpi-image.tiff" out.tiff
}

atf_test_case cat_with_one_file_writes_out_tiff_with_copy_of_file
cat_with_one_file_writes_out_tiff_with_copy_of_file_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat "$(atf_get_srcdir)/data/input-test-file.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/input-test-file.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_writes_out_tiff_with_images_combined_in_one_file
cat_with_multiple_files_writes_out_tiff_with_images_combined_in_one_file_body() {
    expected_message="3 images written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-cat-file.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_and_multiple_images_writes_out_tiff_with_images_combined_in_one_file
cat_with_multiple_files_and_multiple_images_writes_out_tiff_with_images_combined_in_one_file_body() {
    expected_message="4 images written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/expected-cat-file.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-cat-file.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_issues_warning_if_all_not_same_dimensions
cat_with_multiple_files_issues_warning_if_all_not_same_dimensions_body() {
    expected_message="Warning: Sizes of concatenated images are not the same; this will lead to problems in choosing the appropriate image in some cases.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file.tiff: 64x64 points (64x64 pixels, 72x72 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file-4x4.tiff: 4x4 points (4x4 pixels, 72x72 dpi)
2 images written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file-4x4.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-different-size-cat-file.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_does_not_issue_warning_if_point_sizes_are_the_same
cat_with_multiple_files_does_not_issue_warning_if_point_sizes_are_the_same_body() {
    expected_message="2 images written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file@3.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-hidpi.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_warning_calculates_points_based_on_72_dpi
cat_with_multiple_files_warning_calculates_points_based_on_72_dpi_body() {
    expected_message="Warning: Sizes of concatenated images are not the same; this will lead to problems in choosing the appropriate image in some cases.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file.tiff: 64x64 points (64x64 pixels, 72x72 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file-100dpi.tiff: 92.16x92.16 points (128x128 pixels, 100x100 dpi)
2 images written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file-100dpi.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-different-dpi-cat-file.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_warning_handles_different_x_and_y_dpi
cat_with_multiple_files_warning_handles_different_x_and_y_dpi_body() {
    expected_message="Warning: Sizes of concatenated images are not the same; this will lead to problems in choosing the appropriate image in some cases.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file.tiff: 64x64 points (64x64 pixels, 72x72 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file-weird-dpi.tiff: 46.08x64 points (64x64 pixels, 100x72 dpi)
2 images written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file-weird-dpi.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-weird-dpi-file.tiff" out.tiff
}

atf_test_case cat_with_multiple_files_warning_handles_noninteger_dpi
cat_with_multiple_files_warning_handles_noninteger_dpi_body() {
    expected_message="Warning: Sizes of concatenated images are not the same; this will lead to problems in choosing the appropriate image in some cases.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file.tiff: 64x64 points (64x64 pixels, 72x72 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file-decimal-dpi.tiff: 6.78735x37.32685 points (64x64 pixels, 678.91x123.45 dpi)
2 images written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file-decimal-dpi.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-decimal-dpi-file.tiff" out.tiff
}

atf_test_case cat_with_hidpi_mode_writes_image_with_normalized_dpi
cat_with_hidpi_mode_writes_image_with_normalized_dpi_body() {
    expected_message="2 images written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cathidpicheck \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file@2.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-hidpi-image.tiff" out.tiff
}

atf_test_case cat_with_hidpi_mode_issues_warning_when_images_do_not_meet_requirement
cat_with_hidpi_mode_issues_warning_when_images_do_not_meet_requirement_body() {
    expected_message="Warning: Sizes of concatenated images do not follow Aqua guidelines for resolution independent multi-image TIFFs.
         Please provide two images, one with exactly twice the pixel width as the other.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file.tiff: 64x64 points (64x64 pixels, 72x72 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file@3.tiff: 64x64 points (192x192 pixels, 216x216 dpi)
2 images written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cathidpicheck \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file@3.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-hidpi-failed_requirements.tiff" out.tiff
}

atf_test_case cat_with_hidpi_mode_issues_warning_when_too_few_images
cat_with_hidpi_mode_issues_warning_when_too_few_images_body() {
    expected_message="Warning: Sizes of concatenated images do not follow Aqua guidelines for resolution independent multi-image TIFFs.
         Please provide two images, one with exactly twice the pixel width as the other.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file@3.tiff: 64x64 points (192x192 pixels, 216x216 dpi)
1 image written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cathidpicheck \
        "$(atf_get_srcdir)/data/input-test-file@3.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-hidpi-single-image.tiff" out.tiff
}

atf_test_case cat_with_hidpi_mode_issues_warning_when_too_many_images
cat_with_hidpi_mode_issues_warning_when_too_many_images_body() {
    expected_message="Warning: Sizes of concatenated images do not follow Aqua guidelines for resolution independent multi-image TIFFs.
         Please provide two images, one with exactly twice the pixel width as the other.
 Image 1 in file $(atf_get_srcdir)/data/input-test-file.tiff: 64x64 points (64x64 pixels, 72x72 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file@2.tiff: 64x64 points (128x128 pixels, 144x144 dpi)
 Image 1 in file $(atf_get_srcdir)/data/input-test-file@3.tiff: 64x64 points (192x192 pixels, 216x216 dpi)
3 images written to out.tiff.
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cathidpicheck \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file@2.tiff" \
        "$(atf_get_srcdir)/data/input-test-file@3.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-hidpi-too-many-images.tiff" out.tiff
}

atf_test_case cat_with_size_check_suppressed_does_not_issue_warning
cat_with_size_check_suppressed_does_not_issue_warning_body() {
    expected_message="2 images written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -catnosizecheck \
        "$(atf_get_srcdir)/data/input-test-file.tiff" \
        "$(atf_get_srcdir)/data/input-test-file-4x4.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-multi-image-different-size-cat-file.tiff" out.tiff
}

atf_test_case dump_displays_verbatim_info_about_one_image
dump_displays_verbatim_info_about_one_image_body() {
    expected_message="Magic: 0x4949 <little-endian> Version: 0x2a <ClassicTIFF>
Directory 0: offset 12456 (0x30a8) next 0 (0)
ImageWidth (256) SHORT (3) 1<64>
ImageLength (257) SHORT (3) 1<64>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<32773>
Photometric (262) SHORT (3) 1<2>
FillOrder (266) SHORT (3) 1<1>
StripOffsets (273) LONG (4) 1<8>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<64>
StripByteCounts (279) LONG (4) 1<12448>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
ResolutionUnit (296) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>
SampleFormat (339) SHORT (3) 4<1 1 1 1>
ICC Profile (34675) UNDEFINED (7) 3144<00 00 0xc 0x48 0x4c 0x69 0x6e 0x6f 0x2 0x10 00 00 0x6d 0x6e 0x74 0x72 0x52 0x47 0x42 0x20 0x58 0x59 0x5a 0x20 ...>
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -dump \
        "$(atf_get_srcdir)/data/expected-compression-packbits.tiff"
}

atf_test_case dump_displays_verbatim_info_about_multiple_images
dump_displays_verbatim_info_about_multiple_images_body() {
    expected_message="Magic: 0x4949 <little-endian> Version: 0x2a <ClassicTIFF>
Directory 0: offset 9444 (0x24e4) next 13116 (0x333c)
ImageWidth (256) SHORT (3) 1<64>
ImageLength (257) SHORT (3) 1<64>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<8>
Photometric (262) SHORT (3) 1<2>
FillOrder (266) SHORT (3) 1<1>
StripOffsets (273) LONG (4) 1<8>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<64>
StripByteCounts (279) LONG (4) 1<98>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
ResolutionUnit (296) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>
SampleFormat (339) SHORT (3) 4<1 1 1 1>
ICC Profile (34675) UNDEFINED (7) 3144<00 00 0xc 0x48 0x4c 0x69 0x6e 0x6f 0x2 0x10 00 00 0x6d 0x6e 0x74 0x72 0x52 0x47 0x42 0x20 0x58 0x59 0x5a 0x20 ...>

Directory 1: offset 13116 (0x333c) next 13760 (0x35c0)
ImageWidth (256) SHORT (3) 1<128>
ImageLength (257) SHORT (3) 1<128>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<8>
Photometric (262) SHORT (3) 1<2>
StripOffsets (273) LONG (4) 8<3504 3572 3640 3708 3776 3841 3906 3971>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<16>
StripByteCounts (279) LONG (4) 8<68 68 68 68 65 65 65 65>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
Predictor (317) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>

Directory 2: offset 13760 (0x35c0) next 0 (0)
ImageWidth (256) SHORT (3) 1<192>
ImageLength (257) SHORT (3) 1<192>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<8>
Photometric (262) SHORT (3) 1<2>
StripOffsets (273) LONG (4) 20<4310 4382 4454 4526 4598 4670 4742 4814 4886 4958 5031 5099 5167 5235 5303 5371 5439 5507 5575 5643>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<10>
StripByteCounts (279) LONG (4) 20<72 72 72 72 72 72 72 72 72 73 68 68 68 68 68 68 68 68 68 33>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
Predictor (317) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -dump \
        "$(atf_get_srcdir)/data/expected-hidpi-too-many-images.tiff"
}

atf_test_case dump_supports_multiple_images
dump_supports_multiple_images_body() {
    expected_message="*** $(atf_get_srcdir)/data/expected-compression-packbits.tiff
Magic: 0x4949 <little-endian> Version: 0x2a <ClassicTIFF>
Directory 0: offset 12456 (0x30a8) next 0 (0)
ImageWidth (256) SHORT (3) 1<64>
ImageLength (257) SHORT (3) 1<64>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<32773>
Photometric (262) SHORT (3) 1<2>
FillOrder (266) SHORT (3) 1<1>
StripOffsets (273) LONG (4) 1<8>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<64>
StripByteCounts (279) LONG (4) 1<12448>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
ResolutionUnit (296) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>
SampleFormat (339) SHORT (3) 4<1 1 1 1>
ICC Profile (34675) UNDEFINED (7) 3144<00 00 0xc 0x48 0x4c 0x69 0x6e 0x6f 0x2 0x10 00 00 0x6d 0x6e 0x74 0x72 0x52 0x47 0x42 0x20 0x58 0x59 0x5a 0x20 ...>

*** $(atf_get_srcdir)/data/expected-hidpi-too-many-images.tiff
Magic: 0x4949 <little-endian> Version: 0x2a <ClassicTIFF>
Directory 0: offset 9444 (0x24e4) next 13116 (0x333c)
ImageWidth (256) SHORT (3) 1<64>
ImageLength (257) SHORT (3) 1<64>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<8>
Photometric (262) SHORT (3) 1<2>
FillOrder (266) SHORT (3) 1<1>
StripOffsets (273) LONG (4) 1<8>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<64>
StripByteCounts (279) LONG (4) 1<98>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
ResolutionUnit (296) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>
SampleFormat (339) SHORT (3) 4<1 1 1 1>
ICC Profile (34675) UNDEFINED (7) 3144<00 00 0xc 0x48 0x4c 0x69 0x6e 0x6f 0x2 0x10 00 00 0x6d 0x6e 0x74 0x72 0x52 0x47 0x42 0x20 0x58 0x59 0x5a 0x20 ...>

Directory 1: offset 13116 (0x333c) next 13760 (0x35c0)
ImageWidth (256) SHORT (3) 1<128>
ImageLength (257) SHORT (3) 1<128>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<8>
Photometric (262) SHORT (3) 1<2>
StripOffsets (273) LONG (4) 8<3504 3572 3640 3708 3776 3841 3906 3971>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<16>
StripByteCounts (279) LONG (4) 8<68 68 68 68 65 65 65 65>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
Predictor (317) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>

Directory 2: offset 13760 (0x35c0) next 0 (0)
ImageWidth (256) SHORT (3) 1<192>
ImageLength (257) SHORT (3) 1<192>
BitsPerSample (258) SHORT (3) 4<8 8 8 8>
Compression (259) SHORT (3) 1<8>
Photometric (262) SHORT (3) 1<2>
StripOffsets (273) LONG (4) 20<4310 4382 4454 4526 4598 4670 4742 4814 4886 4958 5031 5099 5167 5235 5303 5371 5439 5507 5575 5643>
Orientation (274) SHORT (3) 1<1>
SamplesPerPixel (277) SHORT (3) 1<4>
RowsPerStrip (278) SHORT (3) 1<10>
StripByteCounts (279) LONG (4) 20<72 72 72 72 72 72 72 72 72 73 68 68 68 68 68 68 68 68 68 33>
XResolution (282) RATIONAL (5) 1<72>
YResolution (283) RATIONAL (5) 1<72>
PlanarConfig (284) SHORT (3) 1<1>
Predictor (317) SHORT (3) 1<2>
ExtraSamples (338) SHORT (3) 1<1>
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -dump \
        "$(atf_get_srcdir)/data/expected-compression-packbits.tiff" \
        "$(atf_get_srcdir)/data/expected-hidpi-too-many-images.tiff"
}

atf_test_case dump_with_an_output_filename_fails_with_an_error
dump_with_an_output_filename_fails_with_an_error_body() {
    expected_message="Error: Can't specify output file name for -info, -verboseinfo, or -dump.\n$usage_message\n"
    atf_check -s exit:1 -o inline:"$expected_message" tiffutil -dump \
        "$(atf_get_srcdir)/data/expected-compression-packbits.tiff" -out foo.tiff
}

atf_test_case extract_writes_image_at_offset_to_file
extract_writes_image_at_offset_to_file_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -extract 1 \
        "$(atf_get_srcdir)/data/expected-hidpi-too-many-images.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-extracted-file.tiff" out.tiff
}

atf_test_case info_displays_directory_of_file_with_one_image
info_displays_directory_of_file_with_one_image_body() {
    expected_message="Directory at 0x28a
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: LZW
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -info \
        "$(atf_get_srcdir)/data/expected-compression-lzw.tiff"
}

atf_test_case info_displays_directory_of_file_with_multiple_images
info_displays_directory_of_file_with_multiple_images_body() {
    expected_message="Directory at 0x6a
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
Directory at 0xe12
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
Directory at 0x1bba
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
Directory at 0x2962
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -info \
        "$(atf_get_srcdir)/data/expected-multi-image-cat-file.tiff"
}

atf_test_case info_supports_multiple_images
info_supports_multiple_images_body() {
    expected_message="*** $(atf_get_srcdir)/data/expected-compression-lzw.tiff
Directory at 0x28a
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: LZW
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes

*** $(atf_get_srcdir)/data/expected-multi-image-cat-file.tiff
Directory at 0x6a
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
Directory at 0xe12
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
Directory at 0x1bba
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
Directory at 0x2962
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: AdobeDeflate
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -info \
        "$(atf_get_srcdir)/data/expected-compression-lzw.tiff" \
        "$(atf_get_srcdir)/data/expected-multi-image-cat-file.tiff"
}

atf_test_case info_with_an_output_filename_fails_with_an_error
info_with_an_output_filename_fails_with_an_error_body() {
    expected_message="Error: Can't specify output file name for -info, -verboseinfo, or -dump.\n$usage_message\n"
    atf_check -s exit:1 -o inline:"$expected_message" tiffutil -info \
        "$(atf_get_srcdir)/data/expected-compression-packbits.tiff" -out foo.tiff
}

atf_test_case verboseinfo_is_just_info
verboseinfo_is_just_info_body() {
    expected_message="$(tiffutil -info "$(atf_get_srcdir)/data/expected-compression-lzw.tiff")\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -verboseinfo \
        "$(atf_get_srcdir)/data/expected-compression-lzw.tiff"
}

atf_test_case missing_out_filename_treats_out_as_filename
missing_out_filename_treats_out_as_filename_body() {
    expected_message="Directory at 0x28a
  Image Width: 64 Image Length: 64
  Resolution: 72, 72 pixels/inch
  Bits/Sample: 8
  Sample Format: unsigned integer
  Compression Scheme: LZW
  Photometric Interpretation: RGB color
  Extra Samples: 1<assoc-alpha>
  FillOrder: msb-to-lsb
  Orientation: row 0 top, col 0 lhs
  Samples/Pixel: 4
  Rows/Strip: 64
  Planar Configuration: single image plane
  ICC Profile: <present>, 3144 bytes
"
    cp "$(atf_get_srcdir)/data/expected-compression-lzw.tiff" -- -out
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -info -out
}

atf_test_case no_args_displays_usage
no_args_displays_usage_body() {
    expected_message="$usage_message\n"
    atf_check -s exit:1 -o inline:"$expected_message" tiffutil
}

atf_test_case supports_big_tiff
supports_big_tiff_body() {
    expected_message="1 image written to out.tiff.\n"
    atf_check -s exit:0 -o inline:"$expected_message" tiffutil -cat \
        "$(atf_get_srcdir)/data/input-test-file-bigtiff.tiff"
    atf_check -s exit:0 -o ignore tiffcmp "$(atf_get_srcdir)/data/expected-bigtiff-image.tiff" out.tiff
}

atf_init_test_cases() {
    atf_add_test_case none_writes_out_tiff_with_no_compression
    atf_add_test_case none_with_too_many_filenames_fails_with_an_error

    atf_add_test_case lzw_writes_out_tiff_with_lzw_compression
    atf_add_test_case lzw_with_too_many_filenames_fails_with_an_error

    atf_add_test_case packbits_writes_out_tiff_with_packbits_compression
    atf_add_test_case packbits_with_too_many_filenames_fails_with_an_error

    atf_add_test_case cat_with_hidpi_mode_writes_image_with_normalized_dpi
    atf_add_test_case cat_with_hidpi_mode_issues_warning_when_images_do_not_meet_requirement
    atf_add_test_case cat_with_hidpi_mode_issues_warning_when_too_few_images
    atf_add_test_case cat_with_hidpi_mode_issues_warning_when_too_many_images
    atf_add_test_case cat_with_multiple_files_does_not_issue_warning_if_point_sizes_are_the_same

    atf_add_test_case cat_implements_buggy_dpi_handling
    atf_add_test_case cat_with_multiple_files_and_multiple_images_writes_out_tiff_with_images_combined_in_one_file
    atf_add_test_case cat_with_multiple_files_warning_handles_noninteger_dpi
    atf_add_test_case cat_with_multiple_files_issues_warning_if_all_not_same_dimensions
    atf_add_test_case cat_with_multiple_files_warning_calculates_points_based_on_72_dpi
    atf_add_test_case cat_with_multiple_files_warning_handles_different_x_and_y_dpi
    atf_add_test_case cat_with_multiple_files_writes_out_tiff_with_images_combined_in_one_file
    atf_add_test_case cat_with_size_check_suppressed_does_not_issue_warning

    atf_add_test_case cat_with_one_file_writes_out_tiff_with_copy_of_file

    atf_add_test_case extract_writes_image_at_offset_to_file

    atf_add_test_case dump_displays_verbatim_info_about_one_image
    atf_add_test_case dump_displays_verbatim_info_about_multiple_images
    atf_add_test_case dump_supports_multiple_images
    atf_add_test_case dump_with_an_output_filename_fails_with_an_error

    atf_add_test_case info_displays_directory_of_file_with_one_image
    atf_add_test_case info_displays_directory_of_file_with_multiple_images
    atf_add_test_case info_supports_multiple_images
    atf_add_test_case info_with_an_output_filename_fails_with_an_error

    atf_add_test_case verboseinfo_is_just_info

    atf_add_test_case missing_out_filename_treats_out_as_filename
    atf_add_test_case no_args_displays_usage

    atf_add_test_case supports_big_tiff
}
