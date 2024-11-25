local setmetatable = setmetatable
local type = type
local tinsert = table.insert
local tremove = table.remove

local Timer = C_Timer or {}
C_Timer = Timer
Timer._version = 2 -- This needs to be 2, so others don't replace.

local TickerPrototype = {}
local TickerMetatable = {
	__index = TickerPrototype,
	__metatable = true
}

local waitTable = {}
local waitFrame = TimerFrame or CreateFrame("Frame", "TimerFrame")
waitFrame:SetScript("OnUpdate", function(self, elapsed)
	local wait = #waitTable
	local total = wait
	local i = 1

	while i <= total do
		local ticker = waitTable[i]

		if ( ticker._cancelled ) then
			tremove(waitTable, i)
			total = total - 1
		elseif ( ticker._delay > elapsed ) then
			ticker._delay = ticker._delay - elapsed
			i = i + 1
		else
			ticker._callback(ticker)

			if ( ticker._remainingIterations == -1 ) then
				ticker._delay = ticker._duration
				i = i + 1
			elseif ( ticker._remainingIterations > 1 ) then
				ticker._remainingIterations = ticker._remainingIterations - 1
				ticker._delay = ticker._duration
				i = i + 1
			elseif ( ticker._remainingIterations == 1 ) then
				tremove(waitTable, i)
				total = total - 1
			end
		end
	end

	if ( wait == 0 ) then
		self:Hide()
	end
end)

local function AddDelayedCall(ticker, oldTicker)
	if ( oldTicker and type(oldTicker) == "table" ) then
		ticker = oldTicker
	end

	tinsert(waitTable, ticker)
	waitFrame:Show()
end

_G.AddDelayedCall = AddDelayedCall

local function CreateTicker(duration, callback, iterations)
	local ticker = setmetatable({}, TickerMetatable)
	ticker._remainingIterations = iterations or -1
	ticker._duration = duration
	ticker._delay = duration
	ticker._callback = callback

	AddDelayedCall(ticker)

	return ticker
end

function Timer.After(duration, callback, _)
	if ( _ ) then
		duration = callback
		callback = _
	end

	AddDelayedCall({
		_remainingIterations = 1,
		_delay = duration,
		_callback = callback
	})
end

function Timer.NewTimer(duration, callback, _)
	if ( _ ) then
		duration = callback
		callback = _
	end

	return CreateTicker(duration, callback, 1)
end

function Timer.NewTicker(duration, callback, iterations, _)
	if ( _ ) then
		duration = callback
		callback = iterations
		iterations = _
	end

	return CreateTicker(duration, callback, iterations)
end

function TickerPrototype:Cancel()
	self._cancelled = true
end

function TickerPrototype:IsCancelled()
	return self._cancelled
end