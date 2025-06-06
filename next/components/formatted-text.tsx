import parse, {
  Element,
  HTMLReactParserOptions,
  domToReact,
} from "html-react-parser"
import Image from "next/image"
import Link from "next/link"

import { isRelative } from "lib/utils"

const options: HTMLReactParserOptions = {
  replace: (domNode) => {
    if (domNode instanceof Element) {
      if (domNode.name === "img") {
        const {
          src,
          alt,
          class: className,
          width = '100',
          height = '100',
        } = domNode.attribs

        if (isRelative(src)) {
          return (
            <div className={className}>
              <Image
                src={`${src}`}
                width={parseInt(width)}
                height={parseInt(height)}
                alt={alt}
                objectFit="cover"
              />
            </div>
          )
        }
      }

      if (domNode.name === "a") {
        const { href, class: className } = domNode.attribs

        if (href && isRelative(href)) {
          return (
            <Link href={href} passHref legacyBehavior={true}>
              <a className={className}>{domToReact(domNode.children)}</a>
            </Link>
          )
        }
      }
    }
  },
}

interface FormattedTextProps {
  text?: string
}

export function FormattedText({ text }: FormattedTextProps) {
  if (!text) return null

  return <>{parse(text, options)}</>
}
