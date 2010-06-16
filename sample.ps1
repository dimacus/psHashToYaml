$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Import-Module "$scriptDir\psHashToYaml.psm1"

$a = @{}

$a.a = "1"
$a.b = "2"
$a.c = "a", "b", "c", "3"

$a.d = @{}
$a.d.da = "4"

$a.d.db = @{}
$a.d.db.u = "1"
$a.d.db.z = "2"

$a.nested_hash = @{}
$a.nested_hash.string = "hello world"
$a.nested_hash.array = "this", "is", "an", "array"

$a.nested_hash.hash = @{}
$a.nested_hash.hash.value1 = "one"
$a.nested_hash.hash.value2 = "two"
$a.nested_hash.hash.value3 = "three"

write-host -ForegroundColor Cyan (Convert-HashToYaml $a)

Remove-Module psHashToYaml
