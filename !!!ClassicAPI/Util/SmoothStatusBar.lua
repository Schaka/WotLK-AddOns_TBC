-- https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/SmoothStatusBar.lua
if not SmoothStatusBarMixin then
	local pairs = pairs
	local abs = math.abs

	local g_updatingBars = {};

	local function IsCloseEnough(bar, newValue, targetValue)
		local min, max = bar:GetMinMaxValues();
		local range = max - min;
		if range > 0 then
			return abs((newValue - targetValue) / range) < .00001;
		end

		return true;
	end

	local function ProcessSmoothStatusBars(self, elapsed)
		for bar, targetValue in pairs(g_updatingBars) do
			local effectiveTargetValue = Clamp(targetValue, bar:GetMinMaxValues());
			local newValue = FrameDeltaLerp(bar:GetValue(), effectiveTargetValue, .25, elapsed);

			if IsCloseEnough(bar, newValue, effectiveTargetValue) then
				g_updatingBars[bar] = nil;
				bar:SetValue(effectiveTargetValue);
			else
				bar:SetValue(newValue);
			end
		end
	end

	CreateFrame("Frame"):SetScript("OnUpdate", ProcessSmoothStatusBars)

	SmoothStatusBarMixin = {};

	function SmoothStatusBarMixin:ResetSmoothedValue(value) --If nil, tries to set to the last target value
		local targetValue = g_updatingBars[self];
		if targetValue then
			g_updatingBars[self] = nil;
			self:SetValue(value or targetValue);
		elseif value then
			self:SetValue(value);
		end
	end

	function SmoothStatusBarMixin:SetSmoothedValue(value)
		g_updatingBars[self] = value;
	end

	function SmoothStatusBarMixin:SetMinMaxSmoothedValue(min, max)
		self:SetMinMaxValues(min, max);

		local targetValue = g_updatingBars[self];
		if targetValue then
			local ratio = 1;
			if max ~= 0 and self.lastSmoothedMax and self.lastSmoothedMax ~= 0 then
				ratio = max / self.lastSmoothedMax;
			end

			g_updatingBars[self] = targetValue * ratio;
		end

		self.lastSmoothedMin = min;
		self.lastSmoothedMax = max;
	end
end