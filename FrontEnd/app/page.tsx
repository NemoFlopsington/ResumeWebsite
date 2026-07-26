
import HeroBanner from "./components/HeroBanner/HeroBanner";
import HomeSection from "./components/HomeSection/HomeSection";
import Navbar from "./components/Navbar/Navbar";
import { BioProvider } from "./providers/BioProvider";
import "./page.css";

export default function Home() {
  return (
    <main>
      <Navbar />
      <HeroBanner />
      <BioProvider>
        <HomeSection />
      </BioProvider>
    </main>
  );
}
