import Link from "next/link";
import React from "react";

interface WeekSelectorProps {
  currentWeekNo: number;
}

const WeekSelector = ({ currentWeekNo }: WeekSelectorProps) => {
  const nextWeekLink = currentWeekNo == 17 ? 17 : currentWeekNo + 1;
  const preWeekLink = currentWeekNo == 1 ? 1 : currentWeekNo - 1;

  return (
    <div className="flex flex-col items-center text-xl min-w-[50%]">
      <h1>Week - {currentWeekNo}</h1>
      <div className="flex justify-between w-full text-6xl">
        <Link href={`/${preWeekLink}`}>
          <span>&#60;</span>
        </Link>
        <Link href={`/${nextWeekLink}`}>
          <span>&#62;</span>
        </Link>
      </div>
    </div>
  );
};

export default WeekSelector;
