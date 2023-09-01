# helper function for _skim_preview_file
function _skim_report_file_type --argument-names file_path file_type --description "Explain the file type for a file."
    set_color red
    echo "Cannot preview '$file_path': it is a $file_type."
    set_color normal
end