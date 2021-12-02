-- DEUS ORION BAN SYSTEM
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- Init Main System and its Tables.
Deus.Orion = {...}
Deus.Orion.Bans = {}

-- Deus.Orion.Refresh | Purpose: Reload and Initialize Ban Adam into Table.
function Deus.Orion.Refresh()

	-- If Ban Adam is absent, create it.
	if not file.Exists("deus/adam/bans.json","DATA") then
		file.Write("deus/adam/bans.json", util.TableToJSON(Deus.Orion.Bans))
	end

	-- Feed the adam into a table.
	local JSONData = file.Read("deus/adam/bans.json")
	Deus.Orion.Bans = util.JSONToTable(JSONData)

	-- DEBUG: Print the Table.
	--PrintTable(Deus.Orion.Bans)

end

-- Deus.Orion.Ban | Purpose: Execute a ban. Sorry, pal.
function Deus.Orion.Ban(eCaller, ePly, iTime, sReason)

	-- If the Ban already exists, do not do anything.
	if Deus.Orion.Bans[ePly:SteamID()] != nil then return end

	-- Else, add to Bans.
	Deus.Orion.Bans[ePly:SteamID()] = {}

	-- Banned By...
	Deus.Orion.Bans[ePly:SteamID()]["banner"] = {}
	Deus.Orion.Bans[ePly:SteamID()]["banner"]["ID"] = eCaller:SteamID()
	Deus.Orion.Bans[ePly:SteamID()]["banner"]["name"] = eCaller:Nick()

	-- General Info...
	Deus.Orion.Bans[ePly:SteamID()]["baninfo"] = {}
	Deus.Orion.Bans[ePly:SteamID()]["baninfo"]["when"] = os.date("[%d/%m/%Y | %H:%M:%S] " , Timestamp)
	Deus.Orion.Bans[ePly:SteamID()]["baninfo"]["time"] = tonumber(iTime)
	Deus.Orion.Bans[ePly:SteamID()]["baninfo"]["reason"] = tostring(sReason)

	-- Write it to the Ban Adam.
	file.Write("deus/adam/bans.json", util.TableToJSON(Deus.Orion.Bans))

	-- Refresh Bantable.
	Deus.Orion.Refresh()

end

-- Deus.Orion.RMBan | Purpose: Welcome people to their second chance!
function Deus.Orion.RMBan(eCaller, ePly)

	-- If the ban does NOT exist, do not do anything.
	if Deus.Orion.Bans[ePly:SteamID()] == nil then return end

	-- Else, remove ban.
	Deus.Orion.Bans[ePly:SteamID()] = nil
	file.Write("deus/adam/bans.json", util.TableToJSON(Deus.Orion.Bans))

	-- Refresh Bantable.
	Deus.Orion.Refresh()

end

-- Deus.Orion.chkbn | Purpose: Check ban and defend server against you.
function Deus.Orion.chkbn(steamid64, ip, password, clpassword, name)

	-- Convert 64 SID into 32 SID.
	local steamid = util.SteamIDFrom64(steamid64)

	-- Feed Bandata into variable.
	local bdat = Deus.Orion.Bans[steamid]
	-- Is the variable valid?
	if not bdat then return end
	if not bdat["banner"] and not bdat["baninfo"] then return end
	print("[DEUS] BANNED USER TRYING TO JOIN!")
	print("---------------------------------------------------")
	PrintTable(bdat)
	print("---------------------------------------------------")
	-- Returning false and thus returning you to menu. Hey hey, Goodbye!
	local message = "[DEUS] Banned " .. bdat["baninfo"]["when"] .. " by " .. bdat["banner"]["name"] .. " (" .. bdat["banner"]["ID"] .. ").\n\nReason:\n" .. bdat["baninfo"]["reason"]
	return false, message

end
