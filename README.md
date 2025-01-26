# hoyo-codes-api

 API to get gift codes for Hoyoverse games.  

## Endpoints (sites are from the original creator https://github.com/seriaati)

- Genshin: <https://hoyo-codes.seria.moe/codes?game=genshin>
- Honkai Star Rail: <https://hoyo-codes.seria.moe/codes?game=hkrpg>
- Honkai Impact 3rd: <https://hoyo-codes.seria.moe/codes?game=honkai3rd>
- Zenless Zone Zero: <https://hoyo-codes.seria.moe/codes?game=zzz>
- Tears of Themis: <https://hoyo-codes.seria.moe/codes?game=tot>

## How it Works

- The `run.py` file is responsible for running the API
- The `update.py` file is used to fetch codes from the sources listed in `/api/codes/sources.py`
- The `check.py` file is used to check the status of old codes to see if they have expired

### update.py

 1. We first use `aiohttp` to get the website's HTML. For pockettactics you would need a user agent, else the website blocks you, this is why the `fake-useragent` package is used
 2. Then we parse the HTML using `beautifulsoup` + `lxml` (for faster parsing), then extract the codes from the website by inspecting the HTML elements
 > **I disabled this next feature for now, because I would have to use my hoyo account and I don't want to nuke it. Might search for an alternative in future.**
 3. Next we verify the status of the each code with `genshin.py`, we would request to HoYoLAB to redeem a specific code, and save the code with different `CodeStatus` (OK or NOT_OK) based on the redemption result. If the code already exists in the database, we would skip the verification process

### API

The API grabs the codes from the database with `CodeStatus.OK` and game with the game requested
