--[[
    Welcome, FICSIT Pioneer! This script is your trusty automation sidekick for managing nicknames in the ever-expanding FICSIT Network.
    Tired of running around your factories, manually assigning cutesy nicknames to your industrious machines? Fear not, for this script is lazier than you,
    and that's a *feature*.

    Here's what it does:
    - Scans the entire FICSIT Network (yes, every corner of your spaghetti cabling) and assigns nicknames to components based on
      their location, type, and—if they're fancy enough to have one—a recipe.
    - For machines of the *manufacturer class* (you know, the big chonky boys with recipe options), it cleverly integrates their recipe into the nickname.

    **Function Highlight:**
    - `getComponentName()` — the magical nickname shortener. It trims those long-winded FICSIT component names down to something your brain can process
      before your coffee kicks in.

    **What happens when it gets confused?**
    - If the script stumbles upon an alien species of component (aka, something from mods or what i forgot to add), it will be added to the
      `unhandledComponents` table. The script will yell at you politely via the console, and you can then teach it the names of these strange
      components. Just update `getComponentName()` with your preferred nicknames and hit the rerun button. (If you add one yourself and program it on your own.)

    **How to use this masterpiece:**
    1. Start with `WRITE_DATA = false` and `DEBUG = true` to gather reconnaissance. This way, you’ll get a detailed list of components without
       actually renaming anything. It's like a factory census, but cooler.
    2. If you're one of those people who hates nicknames, set `ORIGIN_NAMES = true` and the script will respect your wish to keep things boring
       and literal. No judgment... much.
    3. You can even customize the nickname format! Check out `COMPOSE` and change the order by your heart's desire. By default, it's in order
    "location, component, component-idx/unick, recipe" because who doesn't love a good spreadsheet aesthetic?

    **Pro Tips:**
    - Got machines without recipes? No problem. The script handles them gracefully, and you can set `EMPTY_RECIPE` to add a placeholder like
      "recipeNotSet" if you’re feeling pedantic.
    - Want to exclude some types or specific components from the scan? Use `FILTER_TYPES` and `EXCLUDE_COMPONENTS` to micromanage like the
      factory overlord you are.
    - Feeling chaotic? Use `DELETE_NICKS` to purge all nicknames from your network. (Just remember to set `WRITE_DATA = true`, and maybe make
      peace with the impending chaos first.)
    - Dealing with Unknown Components? Set `POPULATE_UNKNOWNS = true` and let the script lazily slap the nickname "unknown" onto any mystery components
      that wander into your network. After all, if FICSIT hasn't figured out what it is yet, why should you? It's like giving your robots a
     "hello, my name is" sticker... without actually knowing what they're doing.


    **A Word of Caution:**
    If your builds goes kaboom because of a deleted nickname that caused your nuclear plant to have a minor existential crisis... that's on you.
    I'm just an anonymous amateur programmer who used to mess around with BASIC and decided one bored night that I couldn't be bothered
    assigning nicknames manually anymore. So, I made this. Handle it with care—or don’t. But if it goes wrong, you’re licking up the consequences.

    p.e.a.c.e. — 12/2024

    -- PS: For some unknown reason, the script refuses to change/delete the nickname of routers. No idea why, but that's the cold, hard reality of FICSIT technology.
    Maybe this computer attached to it refuse to change name of its own hand... Good thing is, that you will not change the name of the router accidentally ;)
    If you're absolutely desperate to rename that router, you’ll need to put on your overalls, track down the cursed device, and manually give it a new name.
    I'm sorry, but the code has its limits. Maybe it's a feature... or maybe it's just FICSIT being FICSIT. Thanks for understanding, brave network warrior.

]]--

-- network initialization
local thisNetwork = component.findComponent("")
print("TOTAL COMPONENTS FOUND:", #thisNetwork)

-- data initialization
local COUNTER = 1
local counts = {}
local unhandledComponents = {}

-- SETTINGS --
DELETE_NICKS        = false	-- default false - apply filters as you wish and WRITE_DATA must be true
POPULATE_UNKNOWNS   = false -- default false - populate unknown components with nick "unknown"
ORIGIN_NAMES        = false -- default false - keep original names instead shortened names
EMPTY_RECIPE        = false -- default false - write "recipeNotSet" if recipe is empty to nick
WRITE_DATA          = true 	-- default true  - set to false to only see summary
DEBUG               = false	-- default false - set to true to see detailed info
COMPOSE  = "location, component, component-idx, recipe" -- change order - default: "location, component, component-idx, recipe"
LOCATION = "GreenHell" -- <<< Set your desired location for nick. If you dont want to use location in nick, set it to empty string ""
-- with default order it will set the nick as: "GreenHell Constructor Constructor158 Screws"

-- FILTERING SETTINGS
FILTER_TYPES    = {} -- Example: { "Build_AssemblerMk1_C" , "Build_ConstructorMk1_C" } only include these types
EXCLUDE_COMPONENTS = { "Build_ComputerCase_C" ," Build_NetworkCard_C ", "Build_PowerPoleMk3_C" } -- Example: {"Build_ComputerCase_C" , "Build_NetworkCard_C " }
-- exclude these components


--- FUNCTIONS ---
-- Function to get the shortened name of a component
function getComponentName(machineType)

    -- Mining and Resource Extraction
    if machineType == "Build_AB_MiniEx_C" then return "MiniExtractor"
    elseif machineType == "Build_MinerMk1_C" then return "MinerMk1_"
    elseif machineType == "Build_MinerMk2_C" then return "MinerMk2_"
    elseif machineType == "Build_MinerMk3_C" then return "MinerMk3_"
    elseif machineType == "Build_OilPump_C" then return "OilExtractor"
    elseif machineType == "Build_WaterPump_C" then return "WaterExtractor"
    elseif machineType == "Serie_WaterPump_C" then return "WaterExtractor.s"
    elseif machineType == "Build_BigWaterExtractor_C" then return "BigWaterExtractor"

        -- Production Machines
    elseif machineType == "Build_AB_FluidPacker_C" then return "AI.Packager"
    elseif machineType == "Build_AssemblerMk1_C" then return "Assembler"
    elseif machineType == "Serie_Assembler_C" then return "Assembler.s"
    elseif machineType == "Build_Blender_C" then return "Blender"
    elseif machineType == "Serie_Blender_C" then return "Blender.s"
    elseif machineType == "Build_ConstructorMk1_C" then return "Constructor"
    elseif machineType == "Serie_Const_C" then return "Constructor.s"
    elseif machineType == "Build_FoundryMk1_C" then return "Foundry"
    elseif machineType == "Serie_Foundry_C" then return "Foundry.s"
    elseif machineType == "Build_GreenHouse_C" then return "GreenHouse"
    elseif machineType == "Build_ManufacturerMk1_C" then return "Manufacturer"
    elseif machineType == "Serie_Manufacturer_C" then return "Manufacturer.s"
    elseif machineType == "Build_OilRefinery_C" then return "Refinery"
    elseif machineType == "Serie_Refinery_C" then return "Refinery.s"
    elseif machineType == "Build_Packager_C" then return "Packager"
    elseif machineType == "Serie_Packager_C" then return "Packager.s"
    elseif machineType == "Build_SmelterMk1_C" then return "Smelter"
    elseif machineType == "Serie_Smelt_C" then return "Smelter.s"
    elseif machineType == "Build_HadronCollider_C" then return "ParticleAccelerator"
    elseif machineType == "Serie_Hadron_C" then return "ParticleAccelerator.s"
    elseif machineType == "Build_Converter_C" then return "Converter"
    elseif machineType == "Build_QuantumEncoder_C" then return "QuantumEncoder"

        -- Fluid Management
    elseif machineType == "Build_GlassTank_4Pipes_C" then return "GlassTank4Pipes"
    elseif machineType == "Build_GlassTank_C" then return "GlassTank"
    elseif machineType == "BigStorage_C" then return "BigStorageTank"
    elseif machineType == "Build_IndustrialTank_C" then return "IndustrialTank"
    elseif machineType == "Build_PipelinePumpMk2_C" then return "PipelinePumpMk2_"
    elseif machineType == "Build_PipelinePump_C" then return "PipelinePump"
    elseif machineType == "Serie_PipelinePump_C" then return "PipelinePump"
    elseif machineType == "SeriePipePumpMK2_C" then return "PipePumpMK2_"
    elseif machineType == "Build_PipeStorageTank_C" then return "PipeStorageTank"

        -- Energy Generation
    elseif machineType == "Build_GeneratorBiomass_Automated_C" then return "BiomassGenerator"
    elseif machineType == "Serie_Biomass_C" then return "BiomassGenerator.s"
    elseif machineType == "Build_GeneratorCoal_C" then return "CoalGenerator"
    elseif machineType == "Serie_GenCoal_C" then return "CoalGenerator.s"
    elseif machineType == "Build_GeneratorFuel_C" then return "FuelGenerator"
    elseif machineType == "Serie_FuelGen_C" then return "FuelGenerator.s"
    elseif machineType == "Build_RP_WindTurbine_Mk1_C" then return "WindTurbine"
    elseif machineType == "Build_GeneratorGeoThermal_C" then return "GeoThermalGenerator"
    elseif machineType == "Build_AlienPowerBuilding_C" then return "AlienPower"
    elseif machineType == "Build_GeneratorNuclear_C" then return "NuclearGenerator"
    elseif machineType == "Serie_Nuclear_C" then return "NuclearGenerator.s"

        -- Power and Control
    elseif machineType == "Build_PowerPoleMk1_C" then return "PowerPoleMK1_"
    elseif machineType == "Build_PowerPoleMk2_C" then return "PowerPoleMk2_"
    elseif machineType == "Build_PowerPoleMk3_C" then return "PowerPoleMk3_"
    elseif machineType == "Build_PowerStorageMk1_C" then return "Battery"
    elseif machineType == "Build_PowerSwitch_C" then return "PowerSwitch"
    elseif machineType == "Build_PowerTower_C" then return "PowerTower"
    elseif machineType == "Build_PowerTowerPlatform_C" then return "PowerTowerPlatform"
    elseif machineType == "Build_PriorityPowerSwitch_C" then return "PriorityPowerSwitch"
    elseif machineType == "Serie_StackPole_C" then return "StackPole"

        -- Transportation
    elseif machineType == "Build_TrainStation_C" then return "TrainStation"
    elseif machineType == "Build_TruckStation_C" then return "TruckStation"
    elseif machineType == "Build_RailroadBlockSignal_C" then return "RailBLockSignal"
    elseif machineType == "Build_RailroadPathSignal_C" then return "RailPathSignal"
    elseif machineType == "Build_PipeHyperStart_C" then return "PipeHyperStart"
    elseif machineType == "Serie_HyperTubeEntrance_C" then return "HyperTubeEntrance"
    elseif machineType == "Build_DroneStation_C" then return "DroneStation"
    elseif machineType == "Build_Elevator_8x8_MK1_C" then return "Build_Elevator_8x8_MK1_"
    elseif machineType == "Build_Elevator_8x8_MK2_C" then return "Build_Elevator_8x8_MK2_"
    elseif machineType == "Build_VehicleLift_Diagonal_MKI_C" then return "VehicleLift"
    elseif machineType == "Build_PortalSatellite_C" then return "PortalSatellite"
    elseif machineType == "Build_Portal_C" then return "PortalMain"

        -- Storage and Logistics
    elseif machineType == "Build_CentralStorage_C" then return "DimensionalDepot"
    elseif machineType == "Build_StorageContainerMk1_C" then return "StorageMk1_"
    elseif machineType == "Build_StorageContainerMk2_C" then return "StorageMk2_"

        -- FICSIT Network
    elseif machineType == "Build_CodeableMerger_C" then return "CodeableMerger"
    elseif machineType == "Build_CodeableSplitter_C" then return "CodeableSplitter"
    elseif machineType == "Build_ComputerCase_C" then return "Computer"
    elseif machineType == "Build_IndicatorPole_C" then return "IndicatorPole"
    elseif machineType == "Build_NetworkCard_C" then return "NetworkCard"
    elseif machineType == "Build_NetworkRouter_C" then return "Router"
    elseif machineType == "Build_WirelessAccessPoint_C" then return "AccessPoint"
    elseif machineType == "Build_Screen_C" then return "Screen"
    elseif machineType == "Build_Speakers_C" then return "Speaker"
    elseif machineType == "LargeControlPanel" then return "ControlPanel"
    elseif machineType == "LargeVerticalControlPanel" then return "ControlPanelVertical"
    elseif machineType == "Build_VehicleScanner_C" then return "VehicleScanner"

        -- Miscellaneous
    elseif machineType == "Build_AWSINK2_C" then return "AWSink2_"
    elseif machineType == "Build_StreetLight_C" then return "StreetLight"
    elseif machineType == "Build_LightsControlPanel_C" then return "LightsControlPanel"
    elseif machineType == "Build_FloodlightPole_C" then return "FloodLight"
    elseif machineType == "Build_Elevator_8x8_MK3_C" then return "ElevatorMK3_"
    elseif machineType == "Build_JumpPadAdjustable_C" then return "JumpPad"
    elseif machineType == "Build_LandingPad_C" then return "LandingPad"
    elseif machineType == "Serie_Sink_C" then return "ResourceSink.s"
    elseif machineType == "Build_ResourceSink_C" then return "ResourceSink"
    elseif machineType == "Build_RadarTower_C" then return "RadarTower"
    elseif machineType == "Build_FourPost_CatwalkLift_C" then return "Lift4"
    elseif machineType == "Build_SinglePost_CatwalkLift_C" then return "Lift"

    else return "Unknown" -- keep this!
    end
end

-- Function to compose nick based on COMPOSE setting
function composeNick(location, component, unick, recipe, isManufacturer)
    local nickParts = {}
    for part in string.gmatch(COMPOSE, '([^,]+)') do
        part = part:match("^%s*(.-)%s*$")
        if part == "location" and location ~= "" then
            table.insert(nickParts, location)
        elseif part == "component" then
            table.insert(nickParts, component)
        elseif part == "component-idx" then
            table.insert(nickParts, unick)
        elseif part == "recipe" and isManufacturer then
            if recipe ~= "" then
                table.insert(nickParts, recipe)
            elseif EMPTY_RECIPE then
                table.insert(nickParts, "recipeNotSet")
            end
        end
    end
    return table.concat(nickParts, " ")
end

-- Function to check if a component should be included based on FILTER_TYPES and EXCLUDE_COMPONENTS
function shouldIncludeComponent(componentType)
    if #FILTER_TYPES > 0 and not table.contains(FILTER_TYPES, componentType) then
        return false
    end
    if table.contains(EXCLUDE_COMPONENTS, componentType) then
        return false
    end
    return true
end

-- Helper function to check if a table contains a value
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- MAIN --
if WRITE_DATA then
    print("Starting to populate nicks for location " .. LOCATION)
    computer.beep(1, 0.1)
end
if DEBUG then
    print("Scanning machines in " .. LOCATION)
else
    print("Just summary in " .. LOCATION)
end

-- MAIN LOOP
for _, uuid in pairs(thisNetwork) do
    local thisComponent = component.proxy(uuid)
    local longComponentName = thisComponent:getType().name

    -- check if the component should be included
    if not shouldIncludeComponent(longComponentName) then
        if DEBUG then
            print("Excluded component: " .. longComponentName)
        end
        goto continue
    end

    -- deleting nicks
    if DELETE_NICKS then
        thisComponent.nick = ""
        if DEBUG then
            print("Deleted nick for component: " .. longComponentName)
        end
        goto continue
    end

    -- keep ORIGIN_NAMES or not
    if not ORIGIN_NAMES then
        shortComponentName = getComponentName(longComponentName)
    else
        shortComponentName = longComponentName
    end

    -- handle unknown components
    if shortComponentName == "Unknown" then
        table.insert(unhandledComponents, { name = thisComponent:getType().name })
        if not POPULATE_UNKNOWNS then
            if DEBUG then
                print("Unknown component skipped: " .. longComponentName)
            end
            goto continue
        end
    end
    --
    local componentType = component.proxy(uuid):getType()
    local current = componentType
    local level = 0
    local foundManufacturer = false
    local recipeShort = ""

    -- determine if the component is a manufacturer or other type
    while current do
        local objectName = current.name
        if DEBUG then
            if level == 0 then
                print("Component:" .. objectName)
            end
        end
        -- no need for further climbing
        if objectName == "Buildable" then
            break
        end
        -- found the manufacturer so machine with recipe
        if objectName == "Manufacturer" then
            foundManufacturer = true
            break
        end
        -- climb up the tree
        current = current:getParent()
        level = level + 1
    end

    -- prepare the recipe for the nick if the component is a machine with recipe
    if foundManufacturer then
        local recipe = thisComponent:getRecipe() or { name = "" }
        recipeShort = string.gsub(recipe.name, "%s+", "")
        if DEBUG then
            print("Component: " .. componentType.name .." | Recipe:" .. recipeShort)
        end
    end
    -- counter for the same type of component/recipe
    local key = LOCATION .. " " .. shortComponentName .. " " .. recipeShort
    counts[key] = (counts[key] or 0) + 1

    -- prepare unick for the component nick
    local unick = shortComponentName .. counts[key]

    -- set the nick for the component based on the COMPOSE setting
    local nick = composeNick(LOCATION, shortComponentName, unick, recipeShort, foundManufacturer)
    if WRITE_DATA then
        thisComponent.nick = nick
    end
    if DEBUG then
        print("Nick: " .. nick)
    end

    -- Add unknown components to unhandledComponents table
    if shortComponentName == "Unknown" then
        table.insert(unhandledComponents, { name = thisComponent:getType().name})
        if POPULATE_UNKNOWNS and WRITE_DATA then
            thisComponent.nick = nick
            if DEBUG then
                print("Populated unknown component: " .. longComponentName)
            end
        end
    end
    COUNTER = COUNTER + 1

    ::continue::
end

-- Summary output
print("\n--- Summary ---")
local keys = {}
local max_length = 0
for key in pairs(counts) do
    table.insert(keys, key)
    if #key > max_length then
        max_length = #key
    end
end
table.sort(keys)
for _, key in ipairs(keys) do
    print(string.format("%-" .. max_length .. "s %3d", key, counts[key]))
end

-- Handle unprocessed components
if #unhandledComponents > 0 then
    print("\n --- Unhandled Components ---")
    for _, thisComponent in ipairs(unhandledComponents) do
        print("Machine: ", thisComponent.name)
    end
    print("Add these components to getComponentName() function")
end

if WRITE_DATA then
    print("\n--- All nicks set for location " .. LOCATION .. " with total count: " .. #thisNetwork .. " ---")
    computer.beep(1, 0.1)
end

if not DELETE_NICKS and not POPULATE_UNKNOWNS and not ORIGIN_NAMES and not EMPTY_RECIPE and not WRITE_DATA and not DEBUG then
    print("So... why are you even running this code? 😅 You're not deleting any nicks, not populating unknowns, not using original names, not setting empty recipes, and definitely not debugging. I mean, what’s the point here? It's like trying to make a sandwich without bread. Are you secretly testing how much patience you have? Well, I hope you enjoy the show, because it's going to be a very... 'efficient' operation. 😜")
end
-- END OF SCRIPT
