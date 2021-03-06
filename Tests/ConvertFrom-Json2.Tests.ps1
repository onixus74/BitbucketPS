$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "ConvertFrom-Json2" {
	function defProp($obj, $propName, $propValue)
    {
        It "Defines the '$propName' property" {
            $obj.$propName | Should Be $propValue
        }
    }

	$sampleJson = '{"id":"issuetype","name":"Issue Type","custom":false,"orderable":true,"navigable":true,"searchable":true,"clauseNames":["issuetype","type"],"schema":{"type":"issuetype","system":"issuetype"}}'
    $sampleObject = ConvertFrom-Json2 -InputObject $sampleJson

	It "Creates a PSObject out of JSON input" {
        $sampleObject | Should Not BeNullOrEmpty
    }

	defProp $sampleObject 'Id' 'issuetype'
    defProp $sampleObject 'Name' 'Issue Type'
    defProp $sampleObject 'Custom' $false
}
