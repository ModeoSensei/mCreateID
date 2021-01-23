ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

local MenuOpen = false

local position = {
    {x = 440.05 , y = -981.17, z = 30.69 },
}

local Menu = {
    PercentagePanel = true,
    ColourPanel = true,
    checkbox = false,
    hasidentity = false,
    identity = true,
}

local prenomInput, nameInput, tailleInput,sexInput,DateInput, origineInput = nil, nil, nil, nil, nil

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		blockinput = false
		return result --Returns the result
	else
		blockinput = false
		return nil
	end
end

------------ Création du Menu / Sous Menu -----------
RMenu.Add('modeo', 'main', RageUI.CreateMenu("Commissariat Central", "Carte d'identité"))
RMenu:Get('modeo', 'main'):SetRectangleBanner(255, 0, 0, 100)
RMenu:Get('modeo', 'main').Closed = function()
    MenuOpen = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
            if dist <= 1.0 then

               RageUI.Text({
                    message = "Appuyez sur [~r~E~w~] pour parler au ~r~Policier",
                    time_display = 100,
                })

                if IsControlJustPressed(1,51) then
                    openCreateID()
                end
            end
        end
    end
end)

function openCreateID()
    if not MenuOpen then

        MenuOpen = true 
        RageUI.Visible(RMenu:Get('modeo', 'main'), true)

        Citizen.CreateThread(function()
            while MenuOpen do
                Citizen.Wait(1)
        RageUI.IsVisible(RMenu:Get('modeo', 'main'), true, true, true, function()
            RageUI.Checkbox("Acheter une carte d'identité ~r~- ~s~75$",nil, checkbox,{Style = RageUI.CheckboxStyle.Tick},function(Hovered,Active,Selected,Checked)
                if Selected then
                    checkbox = Checked
                    if Checked then
                        Checked = true
                        TriggerServerEvent('modeo:BuyCarte')
                    else
                        Checked = false
                        TriggerServerEvent('modeo:UnBuyCarte')
                    end
                end
            end)

            if checkbox then
            RageUI.Separator('~r~---')

            RageUI.Button("Prénom", nil, {RightLabel = prenom}, true, function(Hovered, Active, Selected)
                if (Selected) then 
                    local prenomInput = KeyboardInput("Votre Prénom :", "", 10)
                    if tostring(prenomInput) == nil then
                        return false
                    else
                        prenom = (tostring(prenomInput))
                        TriggerServerEvent("modeo:UpdatePrenom", tostring(prenomInput))
                    end
                end    
            end)

            RageUI.Button("Nom", nil, {RightLabel = nom}, true, function(Hovered, Active, Selected)
                if Selected then
                    local nameInput = KeyboardInput("Votre Nom :", "", 10)
                    if tostring(nameInput) == nil then
                        return false
                    else
                        nom = (tostring(nameInput))
                        TriggerServerEvent("modeo:UpdateName", tostring(nameInput))
                    end
                end    
            end)
    
            RageUI.Button("Votre Taille(cm)", nil, {RightLabel = taille}, true, function(Hovered, Active, Selected)
                if (Selected) then 
                    local tailleInput = KeyboardInput("Votre Taille :", "", 10)
                    if tostring(tailleInput) == nil then
                        return false
                    else
                        taille = (tostring(tailleInput))
                        TriggerServerEvent("modeo:UpdateTaille", tostring(tailleInput))
                    end
                end    
            end)
    
            RageUI.Button("Sexe", nil, {RightLabel = sex}, true, function(Hovered, Active, Selected)
                if (Selected) then 
                    local sexInput = KeyboardInput("Votre Sex :", "(m/f)", 10)
                    if tostring(sexInput) == nil then
                        return false
                    else
                        sex = (tostring(sexInput))
                        TriggerServerEvent("modeo:Updatesex", tostring(sexInput))
                    end
                end    
            end)
    
            RageUI.Button("Date de Naissance", nil, {RightLabel = datedenaissance}, true, function(Hovered, Active, Selected)
                if (Selected) then 
                    local dateInput = KeyboardInput("Votre Date de Naissance  :", "", 10)
                    if tostring(dateInput) == nil then
                        return false
                    else
                        datedenaissance = (tostring(dateInput))
                        TriggerServerEvent("modeo:Updatedate", tostring(dateInput))
                    end
                end    
            end)
    
            RageUI.Button("Origine (Pays)", nil, {RightLabel = origine}, true, function(Hovered, Active, Selected)
                if (Selected) then 
                    local origineInput = KeyboardInput("Votre Origine  :", "", 20)
                    if tostring(origineInput) == nil then
                        return false
                    else
                        origine = (tostring(origineInput))
                        TriggerServerEvent("modeo:Updateorigine", tostring(origineInput))
                    end
                end    
            end)

            RageUI.Separator('↓ ~r~Valider la création ~w~↓')
            
        RageUI.Button("Valider", nil, { RightBadge = RageUI.BadgeStyle.Tick }, true, function(Hovered, Active, Selected) 
            if (Selected) then
                Menu.hasidentity = true
                Menu.identity = false
                local prenomInput = prenom
                local nomInput = nom
                local dateInput = datedenaissance
                local heightInput = taille
                local sexInput = sex
                local origineInput = origine
            
                if not prenomInput then
                    ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Prénom")
                elseif not nomInput then
                    ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Nom")
                elseif not dateInput then
                    ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Date de naissance") 
                elseif not heightInput then
                    ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Taille")
                elseif not sexInput then
                    ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Sexe")
                elseif not origineInput then
                    ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Origine")
                else
                    ESX.ShowNotification("Identitée Sauvegardée ✅")
                    RageUI.CloseAll()
                    MenuOpen = false
                    end
                end
            end)
        end
    end)
end
        end, function()
        end, 1)

            Citizen.Wait(0)
        end
    end
end)