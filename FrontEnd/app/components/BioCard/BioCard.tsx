"use client";

import { useBio } from "../../providers/BioProvider";
import "./BioCard.css";

export default function BioCard() {
  const { text } = useBio();

  return (
    <div className="home-card bio-card">
      <h2 className="bio-card-title">About Me</h2>
      <img
        src="https://images.unsplash.com/photo-1516321497487-e288fb19713f?auto=format&fit=crop&w=900&q=80"
        alt="Software engineer working at a desk"
        className="bio-card-image"
      />
      <p className="bio-card-text">{text}</p>
    </div>
  );
}
