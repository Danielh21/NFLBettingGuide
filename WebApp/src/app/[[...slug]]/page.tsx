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
      <div className="w-full max-w-5xl items-center grid grid-cols-2 gap-4 text-white">
        {games.map((g, index) => {
          return <GamesRow game={g} key={index}></GamesRow>;
        })}
      </div>
    </main>
  );
}
