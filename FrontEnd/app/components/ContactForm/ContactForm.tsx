import "./ContactForm.css";

export default function ContactForm() {
  return (
    <div className="home-card contact-card">
      <h2 className="contact-card-title">Contact Me</h2>
      <form className="contact-form">
        <input type="text" placeholder="First name" />
        <input type="text" placeholder="Last name" />
        <input type="email" placeholder="Your email" />
        <textarea placeholder="Write your message here" rows={6} />
        <button type="submit">Send Message</button>
      </form>
    </div>
  );
}
