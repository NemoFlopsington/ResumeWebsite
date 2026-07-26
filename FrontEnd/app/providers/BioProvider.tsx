"use client";

import { createContext, useContext, ReactNode } from "react";
import { bioContent } from "../data/bio";

type BioContextType = {
  text: string;
};

const BioContext = createContext<BioContextType | undefined>(undefined);

export function BioProvider({ children }: { children: ReactNode }) {
  return (
    <BioContext.Provider value={{ text: bioContent.text }}>
      {children}
    </BioContext.Provider>
  );
}

export function useBio() {
  const context = useContext(BioContext);

  if (!context) {
    throw new Error("useBio must be used within a BioProvider");
  }

  return context;
}
