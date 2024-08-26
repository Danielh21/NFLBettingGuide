import React from "react";
import { Game } from "../models/Game";
import classNames from "classnames";

interface GameProps {
  game: Game;
}

const GamesRow = ({ game }: GameProps) => {
  const HomeTeamSpread = game.spread_line;
  // const AwayTeamSpread = game.spread_line;
  const HomeTeamSpreadPos = HomeTeamSpread > 0;
  const homeClassName = classNames({
    "text-green-500": HomeTeamSpreadPos,
    "text-red-500": !HomeTeamSpreadPos,
  });
  const AwayTeamSpread = Math.abs(HomeTeamSpread);

  const AwayTeamSpreadPos = AwayTeamSpread > 0;

  const AwayTeamClass = classNames({
    "text-green-500": AwayTeamSpreadPos,
    "text-red-500": !AwayTeamSpreadPos,
  });

  return (
    <div className="flex flex-col">
      <p>
        {game.home_team} <span className={homeClassName}>{HomeTeamSpread}</span>{" "}
        - {game.away_team}{" "}
        <span className={AwayTeamClass}>{AwayTeamSpread}</span>
      </p>
    </div>
  );
};

export default GamesRow;
