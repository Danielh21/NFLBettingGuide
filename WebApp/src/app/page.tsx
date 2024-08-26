import Image from "next/image";
import { GetGames } from "./actions/getGames";
import GamesRow from "./components/gamesRow";

export default async function Home() {
  const games = await GetGames();

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="w-full max-w-5xl items-center grid grid-cols-2 gap-4">
        {games.map((g, index) => {
          return <GamesRow game={g} key={index}></GamesRow>;
        })}
      </div>
    </main>
  );
}
