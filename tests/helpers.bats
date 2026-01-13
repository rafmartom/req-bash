#!/usr/bin/env bats

load '../src/helpers.sh'


@test "xml_add_entries: generates correct XML from multiple arguments" {
    # We use 'run' so the test doesn't crash if the function fails
    run xml_add_entries "my_root" "file" "file1.txt" "file2.txt" "file3.cfg"

    expected=$(cat << 'EOF'
<?xml version="1.0"?>
<my_root>
    <files>
        <file_1>file1.txt</file_1>
        <file_2>file2.txt</file_2>
        <file_3>file3.cfg</file_3>
    </files>
</my_root>
EOF
)

 
    # DEBUG: Print the output so you can see it in the terminal
#    echo "Actual Output: $output" >&3

    # Check status
    [ "$status" -eq 0 ]

    # 3. Robust Comparison: Remove whitespace/newlines from both to compare data only
    # This prevents the test from failing over a single space or tab.
    clean_output=$(echo "$output" | tr -d '[:space:]')
    clean_expected=$(echo "$expected" | tr -d '[:space:]')

    if [ "$clean_output" != "$clean_expected" ]; then
        echo "Expected output"
        echo "${expected}"
        echo "Actual output"
        echo "${output}"
        return 1
    fi
}


@test "xml_add_entries: appends new tags to existing XML input with xml header" {
    # 1. Define the existing XML input
    input_xml='<?xml version="1.0"?><root><objectives><objective_1>somestring</objective_1><objective_2>somestring</objective_2></objectives></root>'

    # 2. Run the function with the input_xml followed by the new tag name and values
    run xml_add_entries "${input_xml}" "my_root" "file" "file1.txt" "file2.txt" "file3.cfg"

    expected=$(cat << 'EOF'
<?xml version="1.0"?>
<my_root>
    <objectives>
        <objective_1>somestring</objective_1>
        <objective_2>somestring</objective_2>
    </objectives>
    <files>
      <file_1>file1.txt</file_1>
      <file_2>file2.txt</file_2>
      <file_3>file3.cfg</file_3>
    </files>
</my_root>
EOF
)

    # DEBUG: Print the output so you can see it in the terminal
#    echo "Actual Output: $output" >&3

    # Check status
    [ "$status" -eq 0 ]

    # 3. Robust Comparison: Remove whitespace/newlines from both to compare data only
    # This prevents the test from failing over a single space or tab.
    clean_output=$(echo "$output" | tr -d '[:space:]')
    clean_expected=$(echo "$expected" | tr -d '[:space:]')

    if [ "$clean_output" != "$clean_expected" ]; then
        echo -e "\nExpected output---------"
        echo "${expected}"
        echo -e "\nActual output-----------"
        echo "${output}"
        return 1
    fi


}


@test "xml_add_entries: appends new tags to existing XML input without xml header" {
    # 1. Define the existing XML input
    input_xml='<root><objectives><objective_1>somestring</objective_1><objective_2>somestring</objective_2></objectives></root>'

    # 2. Run the function with the input_xml followed by the new tag name and values
    run xml_add_entries "${input_xml}" "my_root" "file" "file1.txt" "file2.txt" "file3.cfg"

    expected=$(cat << 'EOF'
<?xml version="1.0"?>
<my_root>
    <objectives>
        <objective_1>somestring</objective_1>
        <objective_2>somestring</objective_2>
    </objectives>
    <files>
      <file_1>file1.txt</file_1>
      <file_2>file2.txt</file_2>
      <file_3>file3.cfg</file_3>
    </files>
</my_root>
EOF
)


    # DEBUG: Print the output so you can see it in the terminal
#    echo "Actual Output: $output" >&3

    # Check status
    [ "$status" -eq 0 ]

    # 3. Robust Comparison: Remove whitespace/newlines from both to compare data only
    # This prevents the test from failing over a single space or tab.
    clean_output=$(echo "$output" | tr -d '[:space:]')
    clean_expected=$(echo "$expected" | tr -d '[:space:]')

    if [ "$clean_output" != "$clean_expected" ]; then
        echo -e "\nExpected output---------"
        echo "${expected}"
        echo -e "\nActual output-----------"
        echo "${output}"
        return 1
    fi


}

