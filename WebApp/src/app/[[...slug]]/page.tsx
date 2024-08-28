import Link from "next/link";
import { GetGames, GetNextWeek } from "../actions/getGames";
import GamesRow from "../components/GamesRow";
import WeekSelector from "../components/WeekSelector";

export default async function Home({ params }: { params: { slug: string } }) {
  const nextWeek = await GetNextWeek();
  const weekNo =
    params.slug == null ? nextWeek.week : Number.parseInt(params.slug);
  const games = await GetGames(weekNo);

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24 text-white">
      <WeekSelector currentWeekNo={weekNo} />
      <div className="w-full max-w-5xl items-center grid grid-cols-2 gap-x-4 gap-y-10 text-white py-10">
        {games.map((g, index) => {
          return (
            <Link href={`game/${g.game_id}`} key={index}>
              <GamesRow game={g}></GamesRow>
            </Link>
          );
        })}
      </div>
    </main>
  );
}
