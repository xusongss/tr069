require "tr-069-biblio_xml"
local lom = require "lom"

tab = lom.parse (tr_069_biblio_xml)
--serialize(tab)

local token={}
function token:serialize(o, key)
	if type(o) == "table" then
		for k,v in pairs(o) do
			if type(v) == "table" and v.tag == key then
				print( key, v[1])
			end
		end
	end
end

local reference={name=token, title=token, hyperlink=token, organization=token, category=token, date=token}
function reference:serialize(o)
	if type(o) == "table" then
		for k,v in pairs(o) do
			if type(v) == "table" and v.tag == "reference" then
				print(v.attr.id)
				self.name:serialize(v, "name")
				self.title:serialize(v, "title")
				self.hyperlink:serialize(v, "hyperlink")
				self.organization:serialize(v, "organization")
				self.category:serialize(v, "category")
				self.date:serialize(v, "date")
			end
		end
	else
	end
end

local bibliography={reference=reference,}

function bibliography:serialize(o)
	if type(o) == "table" then
		for k,v in pairs(o) do
			if type(v) == "table" and v.tag == "bibliography" then
				self.reference:serialize(v)
			end
		end
	else
	end
end

local dm={bibliography = bibliography,}

function dm:serialize(o)

	if type(o) == "table" then
		if o.tag == "dm:document" then
			self.bibliography:serialize(o)
		end
	else
		error("serialize not table ");
	end
	
end
dm:serialize(tab)


