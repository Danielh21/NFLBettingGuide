import React from "react";
import { Tendency } from "../models/Tendecy";

interface TendencyRowProps {
  tendency: Tendency;
}

const TendencyRow = ({ tendency }: TendencyRowProps) => {
  const textDecriptionString = tendency.text_describtion
    .replace(/\[analysis_team_cover\]/g, tendency.analyis_team_cover + "")
    .replace(
      /\[analysis_team_not_cover\]/g,
      tendency.analysis_team_not_cover + ""
    )
    .replace(/\[pushes\]/g, tendency.pushes + "");
  return (
    <div className="border border-white text-white bg-transparent hover:text-black font-semibold py-2 px-4 rounded ">
      <h3 className="text-4xl pb-4">{tendency.tendecyName}</h3>

      <p>{textDecriptionString}</p>
    </div>
  );
};

export default TendencyRow;
