local UIS,VIM,LP,RS=game:GetService("UserInputService"),game:GetService("VirtualInputManager"),game:GetService("Players").LocalPlayer,game:GetService("RunService");
local SG,C3=Instance.new("ScreenGui",game:GetService("CoreGui")),Color3.fromRGB;
local Conf={F=false,M="",T="Cid's Sword",D=5,AS=false,W=false}; -- ระยะ D=5
local S_Pos,W_Pos=Vector3.new(1793,-49,-859),Vector3.new(1959,-45,-88);

LP.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController();
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end);

local function Create(cl,p,pr)
    local i=Instance.new(cl,pr);
    for k,v in pairs(p)do i[k]=v end;
    return i 
end;

local function Round(i,r)
    Create("UICorner",{CornerRadius=UDim.new(0,r),Parent=i})
end;

local M=Create("Frame",{Size=UDim2.new(0,280,0,500),Position=UDim2.new(0.5,-140,0.5,-250),BackgroundColor3=C3(10,10,15),Parent=SG,Active=true,Draggable=true});
Round(M,12);
local Head=Create("Frame",{Size=UDim2.new(1,0,0,45),BackgroundColor3=C3(20,20,30),Parent=M});
Round(Head,12);
Create("UIStroke",{Color=C3(0,255,255),Parent=M});
local Title=Create("TextLabel",{Size=UDim2.new(0.6,0,1,0),Position=UDim2.new(0,15,0,0),Text="HUNSEN HUB V4.8 (5m)",TextColor3=C3(0,255,255),Font=3,TextSize=16,BackgroundTransparency=1,Parent=Head});
local FPS=Create("TextLabel",{Size=UDim2.new(0.4,-15,1,0),Position=UDim2.new(0.6,0,0,0),Text="FPS: 60",TextColor3=C3(255,255,0),Font=3,TextSize=14,BackgroundTransparency=1,Parent=Head});

local fC,lU=0,tick();
RS.RenderStepped:Connect(function()
    fC=fC+1;
    if tick()-lU>=1 then FPS.Text="FPS: "..fC;fC,lU=0,tick()end 
end);

local Cont=Create("ScrollingFrame",{Size=UDim2.new(1,-20,1,-70),Position=UDim2.new(0,10,0,60),CanvasSize=UDim2.new(0,0,0,800),BackgroundTransparency=1,Parent=M});
Create("UIListLayout",{Padding=UDim.new(0,10),HorizontalAlignment="Center",Parent=Cont});

local ToolI=Create("TextBox",{Size=UDim2.new(1,-10,0,35),PlaceholderText="ชื่ออาวุธ...",Text=Conf.T,BackgroundColor3=C3(25,25,35),TextColor3=C3(255,255,255),Parent=Cont});
Round(ToolI,8);
ToolI.FocusLost:Connect(function()Conf.T=ToolI.Text end);

local function Equip()
    local ch=LP.Character;
    if not ch then return end;
    local t=ch:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChild(Conf.T) or LP.Backpack:FindFirstChildOfClass("Tool");
    if t and t.Parent~=ch then ch.Humanoid:EquipTool(t) end 
    return t 
end;

-- ดึงมอนจ่อหน้า ระยะ 5
local function BringMob(target) 
    if target and target:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChild("HumanoidRootPart") then 
        local mHRP = target.HumanoidRootPart
        local pHRP = LP.Character.HumanoidRootPart
        mHRP.Velocity = Vector3.new(0,0,0)
        mHRP.RotVelocity = Vector3.new(0,0,0)
        mHRP.CFrame = pHRP.CFrame * CFrame.new(0, 0, -5) -- ดึงมอนมาจ่อหน้า 5 หน่วย
    end 
end;

local function Summon()
    for _,v in pairs(workspace:GetDescendants()) do 
        if v:IsA("ProximityPrompt") then 
            if v.ObjectText:lower():find("orb") or v.ActionText:lower():find("summon") or v.ActionText:lower():find("เสก") then 
                fireproximityprompt(v, 10) 
            end 
        end 
    end 
end;

local ScanB=Create("TextButton",{Size=UDim2.new(1,-10,0,35),Text="🔄 SCAN MONSTERS",BackgroundColor3=C3(30,30,45),TextColor3=C3(255,255,255),Parent=Cont});
Round(ScanB,8);
local MobS=Create("ScrollingFrame",{Size=UDim2.new(1,-10,0,100),BackgroundColor3=C3(15,15,20),CanvasSize=UDim2.new(0,0,5,0),Parent=Cont});
Round(MobS,8);
Create("UIListLayout",{Parent=MobS});

ScanB.MouseButton1Click:Connect(function()
    for _,v in pairs(MobS:GetChildren())do if v:IsA("TextButton")then v:Destroy()end end;
    local Cache={};
    for _,v in pairs(workspace:GetDescendants())do 
        if v:IsA("Model")and v:FindFirstChild("Humanoid")and v.Humanoid.Health>0 and not Cache[v.Name]and v~=LP.Character then 
            Cache[v.Name]=true;
            local b=Create("TextButton",{Size=UDim2.new(1,0,0,25),Text=v.Name,BackgroundColor3=C3(35,35,45),TextColor3=C3(200,200,200),Parent=MobS});
            b.MouseButton1Click:Connect(function()Conf.M=v.Name;Title.Text="Target: "..v.Name end)
        end 
    end 
end);

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local ch=LP.Character;
            if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end;
            local hrp = ch.HumanoidRootPart;

            if Conf.W then 
                hrp.CFrame=CFrame.new(W_Pos)
            elseif Conf.AS then 
                local boss=nil;
                for _,v in pairs(workspace:GetDescendants()) do 
                    if (v.Name:lower():find("cidboss") or v.Name:lower():find("cid boss")) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 then 
                        boss=v break 
                    end 
                end;
                if boss then 
                    Equip();
                    -- วาร์ปไปข้างหลังบอส ระยะ 5
                    hrp.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5);
                    hrp.CFrame = CFrame.lookAt(hrp.Position, boss.HumanoidRootPart.Position);
                    BringMob(boss);
                    if ch:FindFirstChildOfClass("Tool") then ch:FindFirstChildOfClass("Tool"):Activate() end 
                else 
                    hrp.CFrame=CFrame.new(S_Pos);
                    Summon() 
                end 
            elseif Conf.F and Conf.M~="" then 
                for _,v in pairs(workspace:GetDescendants()) do 
                    if v.Name == Conf.M and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then 
                        -- วาร์ปไปข้างหลังมอนสเตอร์ ระยะ 5
                        hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5);
                        hrp.CFrame = CFrame.lookAt(hrp.Position, v.HumanoidRootPart.Position);
                        Equip();
                        BringMob(v);
                        if ch:FindFirstChildOfClass("Tool") then ch:FindFirstChildOfClass("Tool"):Activate() end 
                    end 
                end 
            end 
        end)
    end 
end);

local WB=Create("TextButton",{Size=UDim2.new(1,-10,0,40),Text="🚌 วาปไปรอรถ: OFF",BackgroundColor3=C3(30,30,45),TextColor3=C3(255,255,255),Parent=Cont});
Round(WB,8);
WB.MouseButton1Click:Connect(function()
    Conf.W=not Conf.W; Conf.F,Conf.AS=false,false;
    WB.Text=Conf.W and "🚌 วาปไปรอรถ: ON" or "🚌 วาปไปรอรถ: OFF";
    WB.BackgroundColor3=Conf.W and C3(0,200,100) or C3(30,30,45)
end);

local FB=Create("TextButton",{Size=UDim2.new(1,-10,0,40),Text="START FARM (Normal)",BackgroundColor3=C3(0,120,200),TextColor3=C3(255,255,255),Parent=Cont});
Round(FB,8);
FB.MouseButton1Click:Connect(function()
    Conf.F=not Conf.F; Conf.AS,Conf.W=false,false;
    FB.Text=Conf.F and "STOP FARM" or "START FARM (Normal)"
end);

local CB=Create("TextButton",{Size=UDim2.new(1,-10,0,45),Text="AUTO CIDBOSS",BackgroundColor3=C3(100,40,200),TextColor3=C3(255,255,255),Parent=Cont});
Round(CB,10);
CB.MouseButton1Click:Connect(function()
    Conf.AS=not Conf.AS; Conf.F,Conf.W=false,false;
    CB.Text=Conf.AS and "STOP CIDBOSS" or "AUTO CIDBOSS" 
end);

local BTN=Create("TextButton",{Size=UDim2.new(0,45,0,45),Text="H",BackgroundColor3=C3(15,15,20),TextColor3=C3(0,255,255),Parent=SG});
Round(BTN,10);
BTN.MouseButton1Click:Connect(function()M.Visible=not M.Visible end)
