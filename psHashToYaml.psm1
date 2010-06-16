
function Get-Indents{
	param ($level)
	$indent    = "  "
	$final_indents = ""
	
	for ($i=1; $i -le $level; $i++) { $final_indents += $indent }
	
	return $final_indents
}

function ArrayToString {
	param($parent_node, $input_array, $level)
	
	$return_string = "$(Get-Indents($level))$($parent_node): ["
	
	foreach ($item in $input_array){
		$return_string += "$item, "
	}
	
	$return_string += "]"
	
	$return_string = $return_string -replace ", ]", "]`n"
	
	return $return_string
}

function HashToString {
	param($parent_node, $input_hash, $level)
	
	$level = $level-1
	
	$return_string = "$(Get-Indents($level+1))$($parent_node):`n"
	
	$return_string += Convert-HashToYaml -hash $input_hash -level ($level + 2) 
	
	return $return_string
}

function HashStringToString {
	param($parent_node, $input_string, $level)

	return "$(Get-Indents($level))$($parent_node): $($input_string)`n"
}

<# 
 .Synopsis
  Returns a YAML converted string from a hash input

 .Description
  Single function that takes in a hash and returns a string

 .Parameter file
  File reference to a yaml document

 .Parameter path
  An input hash
#>

function Convert-HashToYaml {
	param ($hash = $(throw "-hash is required input"), $level = 0)
	
	$final_out = ""
	
	foreach ($node_key in $hash.keys){

		if($hash[$node_key] -is [String]){
			$final_out += (HashStringToString -parent_node $node_key -input_string $hash[$node_key] -level $level)
		} elseif ($hash[$node_key] -is [Array]){
			$final_out += (ArrayToString -parent_node $node_key -input_array $hash[$node_key] -level $level)
		} elseif ($hash[$node_key] -is [HashTable]){
			if ($level -eq 0){
				$final_out +=  (HashToString -parent_node $node_key -input_hash $hash[$node_key] -level $level)
			} else {
				$final_out += "$(Get-Indents($level))$($node_key):`n"
				$final_out += (Convert-HashToYaml -hash $hash[$node_key] -level ($level+1))
			}
		} else {
			throw "Can only accept Strings, Arrays, Hashes as input. Problem with $($root_node_key)"
		}

	}
	
	return $final_out
}

Export-ModuleMember -Function Convert-HashToYaml