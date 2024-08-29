import React from "react";
import { Tendency } from "../models/Tendecy";
import classNames from "classnames";
import Image from "next/image";
import { GetTeamLogo } from "../helpers/TeamHelper";

interface TendencyRowProps {
  tendency: Tendency;
  homeTeamName: string;
  awayTeamName: string;
}

const TendencyRow = ({
  tendency,
  homeTeamName,
  awayTeamName,
}: TendencyRowProps) => {
  const textDecriptionString = tendency.text_describtion
    .replace(/\[analysis_team_cover\]/g, tendency.analyis_team_cover + "")
    .replace(
      /\[analysis_team_not_cover\]/g,
      tendency.analysis_team_not_cover + ""
    )
    .replace(/\[pushes\]/g, tendency.pushes + "");
  const totalGameMinusPushes =
    tendency.analyis_team_cover + tendency.analysis_team_not_cover;
  const percentage = (tendency.analyis_team_cover / totalGameMinusPushes) * 100;
  const analysisTeam = tendency.analyis_team_is_home_team
    ? homeTeamName
    : awayTeamName;

  const precentageCss = classNames({
    "text-red-500": percentage < 50,
    "text-green-200": percentage > 50 && percentage >= 51,
    "text-green-300": percentage > 51 && percentage >= 52,
    "text-green-400": percentage > 52 && percentage >= 54,
    "text-green-500": percentage > 54,
  });
  return (
    <div className="border border-white text-white bg-transparent font-semibold py-2 px-4 rounded ">
      <h3 className="text-4xl pb-4">{tendency.tendecyName}</h3>
      <div className="px-4">
        <p>{textDecriptionString}</p>

        <div className="mt-3">
          <div className="flex gap-4 items-center">
            <p>Team analyze is run for:</p>
            <div className="flex justify-center gap-4 items-center">
              <p>{analysisTeam}</p>
              <Image
                src={GetTeamLogo(analysisTeam)}
                alt="logo"
                width={40}
                height={40}
              />
            </div>
          </div>
          <div className="flex gap-4">
            <p>Covering in:</p>
            <p className={precentageCss}>{percentage.toFixed(2)} %</p>
          </div>
          <div className="flex gap-4">
            <p>Total Games included in tendency:</p>
            <p>{tendency.games_included}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TendencyRow;
