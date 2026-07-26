import Link from "next/link";
import NameTitle from "./NameTitle";
import "./navbar.css";

const tabs = [
  { label: "Home", href: "/" },
  { label: "About", href: "/about" },
  { label: "Resume", href: "/resume" },
  { label: "Projects", href: "/projects" },
];

export default function Navbar() {
  return (
    <nav className="navbar">
      <NameTitle />

      <div className="navbar-links">
        {tabs.map((tab) => (
          <Link key={tab.label} href={tab.href} className="navbar-link">
            {tab.label}
          </Link>
        ))}
      </div>
    </nav>
  );
}
