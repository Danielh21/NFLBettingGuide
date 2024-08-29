import React from "react";
import { Game } from "../models/Game";
import classNames from "classnames";
import Image from "next/image";
import { GetTeamLogo } from "../helpers/TeamHelper";

interface GameProps {
  game: Game;
  hideCounter?: boolean;
}

const GamesRow = ({ game, hideCounter = false }: GameProps) => {
  const HomeTeamSpread = -game.spread_line; //Since it shown oppsite of the betting sites
  const HomeTeamSpreadPos = HomeTeamSpread > 0;
  const homeClassName = classNames({
    "text-green-500": HomeTeamSpreadPos,
    "text-red-500": !HomeTeamSpreadPos,
  });
  const AwayTeamSpread = -HomeTeamSpread;

  const AwayTeamSpreadPos = AwayTeamSpread > 0;

  const AwayTeamClass = classNames({
    "text-green-500": AwayTeamSpreadPos,
    "text-red-500": !AwayTeamSpreadPos,
  });

  const tendencyClassCounter = classNames({
    "text-green-500": game?.numberOfTendencies ?? 0 > 0,
  });

  return (
    <div className="flex flex-col ">
      <div className="flex gap-6">
        <div className="flex flex-col items-center min-w-[40%]">
          <Image
            src={GetTeamLogo(game.home_team)}
            alt="logo"
            width={80}
            height={80}
          />
          <p>
            {game.home_team}{" "}
            <span className={homeClassName}>{HomeTeamSpread}</span>{" "}
          </p>
        </div>
        <div className="flex flex-col items-center min-w-[40%]">
          <Image
            src={GetTeamLogo(game.away_team)}
            alt="logo"
            width={80}
            height={80}
          />
          <p>
            {game.away_team}{" "}
            <span className={AwayTeamClass}>{AwayTeamSpread}</span>
          </p>
        </div>
      </div>
      {!hideCounter && (
        <div className="flex justify-center text-center max-w-[80%] mt-3">
          Tendencies Counter: &nbsp;
          <span className={tendencyClassCounter}>
            {game.numberOfTendencies}
          </span>
        </div>
      )}
    </div>
  );
};

export default GamesRow;
