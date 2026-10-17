#!/usr/bin/env atf-sh

atf_test_case compress_leaves_chunks_alone_8_bit
compress_leaves_chunks_alone_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/expected-compress-8-bit.png" \
        copypng -compress "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case compress_works_with_strip_png_text_8_bit
compress_works_with_strip_png_text_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/expected-compress-strip-png-text-8-bit.png" \
        copypng -compress -strip-PNG-text "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case skips_png_copies_the_file_8_bit
skips_png_copies_the_file_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" \
        copypng -skip-PNGs "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case skips_png_ignores_text_removal_option_8_bit
skips_png_ignores_text_removal_option_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" \
        copypng -skip-PNGs -strip-PNG-text "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case skips_png_ignores_compress_8_bit
skips_png_ignores_compress_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" \
        copypng -skip-PNGs -compress "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case specifying_no_options_just_copies_8_bit
specifying_no_options_just_copies_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" \
        copypng "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case strip_png_text_removes_tEXt_iTXt_zTXt_chunks_8_bit
strip_png_text_removes_tEXt_iTXt_zTXt_chunks_8_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/expected-strip-png-text-8-bit.png" \
        copypng -strip-PNG-text "$(atf_get_srcdir)/data/input-test-file-8-bit.png" /dev/stdout
}

atf_test_case compress_leaves_chunks_alone_16_bit
compress_leaves_chunks_alone_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/expected-compress-16-bit.png" \
        copypng -compress "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case compress_works_with_strip_png_text_16_bit
compress_works_with_strip_png_text_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/expected-compress-strip-png-text-16-bit.png" \
        copypng -compress -strip-PNG-text "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case skips_png_copies_the_file_16_bit
skips_png_copies_the_file_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-16-bit.png" \
        copypng -skip-PNGs "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case skips_png_ignores_text_removal_option_16_bit
skips_png_ignores_text_removal_option_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-16-bit.png" \
        copypng -skip-PNGs -strip-PNG-text "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case skips_png_ignores_compress_16_bit
skips_png_ignores_compress_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-16-bit.png" \
        copypng -skip-PNGs -compress "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case specifying_no_options_just_copies_16_bit
specifying_no_options_just_copies_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-16-bit.png" \
        copypng "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case strip_png_text_removes_tEXt_iTXt_zTXt_chunks_16_bit
strip_png_text_removes_tEXt_iTXt_zTXt_chunks_16_bit_body() {
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/expected-strip-png-text-16-bit.png" \
        copypng -strip-PNG-text "$(atf_get_srcdir)/data/input-test-file-16-bit.png" /dev/stdout
}

atf_test_case copies_non_8_bit_files_when_in_compat_mode
copies_non_8_bit_files_when_in_compat_mode_body() {
    XCODE_HIGH_BIT_DEPTH_COMPAT=1 \
    atf_check -s exit:0 -o inline:'libpng warning: Warning: Input PNG does not have an 8 bit input depth.  Please convert your PNG to 8-bit for optimal performance on iPhone OS.\n' \
        copypng -compress "$(atf_get_srcdir)/data/input-test-file-16-bit.png" result.png
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-16-bit.png" cat result.png
}

atf_test_case exits_with_error_when_no_files
exits_with_error_when_no_files_body() {
    atf_check -s exit:1 -o inline:"ERROR: Can't find\n" \
        copypng
}

atf_test_case exits_with_error_when_no_destination
exits_with_error_when_no_destination_body() {
    atf_check -s exit:1 -o inline:"ERROR: Destination file missing\n" \
        copypng "$(atf_get_srcdir)/data/input-test-file-8-bit.png"
}

atf_test_case reads_relative_paths_to_pwd
reads_relative_paths_to_pwd_body() {
    cp "$(atf_get_srcdir)/data/input-test-file-8-bit.png" input.png
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" \
        copypng input.png /dev/stdout
}

atf_test_case warns_about_unknown_options
warns_about_unknown_options_body() {
    atf_check -s exit:0 -o inline:'WARNING: Ignoring unknown option -totally_legit_option' \
        copypng -totally_legit_option "$(atf_get_srcdir)/data/input-test-file-8-bit.png" result.png
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" cat result.png
}

atf_test_case writes_relative_paths_to_pwd
writes_relative_paths_to_pwd_body() {
    atf_check -s exit:0 \
        copypng "$(atf_get_srcdir)/data/input-test-file-8-bit.png" result.png
    atf_check -s exit:0 -o file:"$(atf_get_srcdir)/data/input-test-file-8-bit.png" cat "$PWD/result.png"
}

atf_init_test_cases() {
    atf_add_test_case compress_leaves_chunks_alone_8_bit
    atf_add_test_case compress_works_with_strip_png_text_8_bit
    atf_add_test_case skips_png_copies_the_file_8_bit
    atf_add_test_case skips_png_ignores_compress_8_bit
    atf_add_test_case skips_png_ignores_text_removal_option_8_bit
    atf_add_test_case specifying_no_options_just_copies_8_bit
    atf_add_test_case strip_png_text_removes_tEXt_iTXt_zTXt_chunks_8_bit

    atf_add_test_case compress_leaves_chunks_alone_16_bit
    atf_add_test_case compress_works_with_strip_png_text_16_bit
    atf_add_test_case skips_png_copies_the_file_16_bit
    atf_add_test_case skips_png_ignores_compress_16_bit
    atf_add_test_case skips_png_ignores_text_removal_option_16_bit
    atf_add_test_case specifying_no_options_just_copies_16_bit
    atf_add_test_case strip_png_text_removes_tEXt_iTXt_zTXt_chunks_16_bit

    atf_add_test_case copies_non_8_bit_files_when_in_compat_mode
    atf_add_test_case exits_with_error_when_no_destination
    atf_add_test_case exits_with_error_when_no_files
    atf_add_test_case reads_relative_paths_to_pwd
    atf_add_test_case warns_about_unknown_options
    atf_add_test_case writes_relative_paths_to_pwd
}
