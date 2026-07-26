import BioCard from "../BioCard/BioCard";
import ContactForm from "../ContactForm/ContactForm";
import "./HomeSection.css";

export default function HomeSection() {
  return (
    <section id="home" className="home-section">
      <BioCard />
      <ContactForm />
    </section>
  );
}
