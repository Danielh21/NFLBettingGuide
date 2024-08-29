import { GetSingleGame, GetTendenciesForGame } from "@/app/actions/getGames";
import GamesRow from "@/app/components/GamesRow";
import TendencyRow from "@/app/components/TendencyRow";
import Link from "next/link";

export default async function Game({ params }: { params: { slug: string } }) {
  const game = await GetSingleGame(params.slug);
  const allTendencies = await GetTendenciesForGame(params.slug);

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24 text-white">
      <div>
        <div className="flex min-w-[70vw] justify-center">
          <GamesRow hideCounter={true} game={game} />
        </div>
        <div className="pt-10">
          {allTendencies.map((t, index) => {
            return (
              <div className="py-10 flex-col flex gap-6" key={index}>
                <TendencyRow
                  homeTeamName={game.home_team}
                  awayTeamName={game.away_team}
                  tendency={t}
                />
              </div>
            );
          })}
        </div>
      </div>
    </main>
  );
}
