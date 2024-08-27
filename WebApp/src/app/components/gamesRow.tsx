import React from "react";
import { Game } from "../models/Game";
import classNames from "classnames";
import Image from "next/image";
import { GetTeamLogo } from "../helpers/TeamHelper";

interface GameProps {
  game: Game;
}

const GamesRow = ({ game }: GameProps) => {
  const HomeTeamSpread = game.spread_line;
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

  return (
    <div className="flex gap-6 ">
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
  );
};

export default GamesRow;
