local function DefineAndRegisterHTTPFilePostdissector()
	local oProtoHTTPFiles = Proto('httpfile', 'HTTP Request URI File Postdissector')
	local oProtoFieldHTTPFile = ProtoField.string('http.urifile', 'URI File', 'The HTTP Request URI')

	oProtoHTTPFiles.fields = {oProtoFieldHTTPFile}

	local oField_http_uri = Field.new('http.request.uri')

	function oProtoHTTPFiles.dissector(buffer, pinfo, tree)	
		local i_http_uri = oField_http_uri()
		local s_http_uri = tostring(i_http_uri)
		if s_http_uri then		
			local s_http_uri_pattern = string.sub(s_http_uri, 0, string.find(s_http_uri, "%?") - 1)
			if s_http_uri_pattern then
				local s_http_uri_file = string.match(s_http_uri_pattern, "[a-zA-Z0-9]+%.[a-zA-Z0-9]+$")			
				if s_http_uri_file then
					local oSubtree = tree:add(oProtoHTTPFiles, 'HTTP Request URI File')
					oSubtree:add(oProtoFieldHTTPFile, s_http_uri_file)
				end	
			end
		end
	end
					
	register_postdissector(oProtoHTTPFiles)
end

local function Main()
	DefineAndRegisterHTTPFilePostdissector()
end

Main()
